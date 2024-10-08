// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC721, ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { MerkleProof } from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import { ITraitForgeNft } from "contracts/interfaces/ITraitForgeNft.sol";
import { IEntityForging } from "contracts/interfaces/IEntityForging.sol";
import { IEntropyGenerator } from "contracts/interfaces/IEntropyGenerator.sol";
import { IAirdrop } from "contracts/interfaces/IAirdrop.sol";
import { AddressProviderResolver } from "contracts/core/AddressProviderResolver.sol";

contract TraitForgeNft is ITraitForgeNft, AddressProviderResolver, ERC721Enumerable, ReentrancyGuard, Pausable {
    modifier onlyWhitelisted(bytes32[] calldata proof, bytes32 leaf) {
        if (block.timestamp <= whitelistEndTime) {
            if (!MerkleProof.verify(proof, rootHash, leaf)) revert TraitForgeNft__NotWhiteListed();
        }
        _;
    }

    modifier onlyEntityForging() {
        if (msg.sender != address(_getEntityForging())) revert TraitForgeNft__OnlyEntityForgingAuthorized(msg.sender);
        _;
    }

    // Constants for token generation and pricing
    uint256 public maxTokensPerGen = 10_000;
    uint256 public startPrice = 0.005 ether;
    uint256 public priceIncrement = 0.0000245 ether;
    uint256 public priceIncrementByGen = 0.000005 ether;

    // Variables for managing generations and token IDs
    uint256 public currentGeneration = 1;
    /// @dev generation limit
    uint256 public maxGeneration = 10;
    /// @dev merkle tree root hash
    bytes32 public rootHash;
    /// @dev whitelist end time
    uint256 public whitelistEndTime;

    // Mappings for token metadata
    mapping(uint256 tokenId => uint256 createdAt) public tokenCreationTimestamps;
    mapping(uint256 tokenId => uint256 lastTransferAt) public lastTokenTransferredTimestamp;
    mapping(uint256 tokenId => uint256 entropy) public tokenEntropy;
    mapping(uint256 generation => uint256 mintCounts) public generationMintCounts;
    mapping(uint256 tokenId => uint256 generation) public tokenGenerations;
    mapping(uint256 tokenId => address initialOwner) public initialOwners;

    uint256 private _tokenIds;
    bool public hasGoldenGodbeenMinted = false; //TODO probably have it per generation

    error TraitForgeNft__NotEnoughTokensMinted();
    error TraitForgeNft__NotWhiteListed();
    error TraitForgeNft__InsufficientETHSent();
    error TraitForgeNft__MaxGenerationReached();
    error TraitForgeNft__MinAmountIsZero();
    error TraitForgeNft__OnlyEntityForgingAuthorized(address caller);
    error TraitForgeNft__CannotForgeWithSameToken();
    error TraitForgeNft__NewGenerationCreatedOverMaxGeneration();

    constructor(
        address addressProvider,
        bytes32 _rootHash
    )
        ERC721("TraitForgeNft", "TFGNFT")
        AddressProviderResolver(addressProvider)
    {
        whitelistEndTime = block.timestamp + 24 hours;
        rootHash = _rootHash;
    }

    //////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////// external & public functions /////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////

    //////////////////////////// write functions ////////////////////////////

    function pause() public onlyProtocolMaintainer {
        _pause();
    }

    function unpause() public onlyProtocolMaintainer {
        _unpause();
    }

    // TODO this function is not needed as it can be executed on the airdrop contract directly
    function startAirdrop(uint256 amount) external whenNotPaused onlyProtocolMaintainer {
        _getAirdrop().startAirdrop(amount);
    }

    function setStartPrice(uint256 _startPrice) external onlyProtocolMaintainer {
        startPrice = _startPrice;
    }

    function setPriceIncrement(uint256 _priceIncrement) external onlyProtocolMaintainer {
        priceIncrement = _priceIncrement;
    }

    function setPriceIncrementByGen(uint256 _priceIncrementByGen) external onlyProtocolMaintainer {
        priceIncrementByGen = _priceIncrementByGen;
    }

    function setMaxGeneration(uint256 maxGeneration_) external onlyProtocolMaintainer {
        require(maxGeneration_ >= currentGeneration, "can't below than current generation");
        maxGeneration = maxGeneration_;
    }

    function setRootHash(bytes32 _rootHash) external onlyProtocolMaintainer {
        rootHash = _rootHash;
    }

    function setWhitelistEndTime(uint256 endTime_) external onlyProtocolMaintainer {
        whitelistEndTime = endTime_;
    }

    function burn(uint256 tokenId) external whenNotPaused nonReentrant {
        require(isApprovedOrOwner(msg.sender, tokenId), "ERC721: caller is not token owner or approved");
        IAirdrop airdropContract = _getAirdrop();
        if (!airdropContract.airdropStarted()) {
            uint256 entropy = getTokenEntropy(tokenId);
            if (msg.sender == initialOwners[tokenId]) {
                airdropContract.subUserAmount(initialOwners[tokenId], entropy);
            }
        }
        _burn(tokenId);
    }

    function forge(
        address newOwner,
        uint256 parent1Id,
        uint256 parent2Id,
        string memory
    )
        external
        whenNotPaused
        nonReentrant
        onlyEntityForging
        returns (uint256)
    {
        uint256 newGeneration = getTokenGeneration(parent1Id) + 1;

        /// Check new generation is not over maxGeneration
        if (newGeneration > maxGeneration) revert TraitForgeNft__NewGenerationCreatedOverMaxGeneration();

        // Calculate the new entity's entropy
        (uint256 forgerEntropy, uint256 mergerEntropy) = getEntropiesForTokens(parent1Id, parent2Id);
        uint256 newEntropy = (forgerEntropy + mergerEntropy) / 2;

        if (ownerOf(parent1Id) == ownerOf(parent2Id)) {
            newEntropy = getInbredEntropy();
        }
        // Mint the new entity
        uint256 newTokenId = _mintNewEntity(newOwner, newEntropy, newGeneration);

        emit NewForgeOccured(newOwner, newTokenId, parent1Id, parent2Id, newGeneration, newEntropy);

        return newTokenId;
    }

    function mintToken(bytes32[] calldata proof)
        public
        payable
        whenNotPaused
        nonReentrant
        onlyWhitelisted(proof, keccak256(abi.encodePacked(msg.sender)))
        returns (uint256)
    {
        if (generationMintCounts[currentGeneration] == maxTokensPerGen) {
            _incrementGeneration();
        }
        uint256 mintPrice = calculateMintPrice();
        if (msg.value < mintPrice) revert TraitForgeNft__InsufficientETHSent();

        uint256 tokenId = _mintInternal(msg.sender, mintPrice);

        uint256 excessPayment = msg.value - mintPrice;
        if (excessPayment > 0) {
            (bool refundSuccess,) = msg.sender.call{ value: excessPayment }("");
            require(refundSuccess, "Refund of excess payment failed.");
        }

        _distributeFunds(mintPrice);

        return tokenId;
    }

    function mintWithBudget(
        bytes32[] calldata proof,
        uint256 minAmountMinted
    )
        public
        payable
        whenNotPaused
        nonReentrant
        onlyWhitelisted(proof, keccak256(abi.encodePacked(msg.sender)))
    {
        if (minAmountMinted == 0) revert TraitForgeNft__MinAmountIsZero();

        uint256 amountMinted = 0;
        uint256 budgetLeft = msg.value;

        // L04
        if (generationMintCounts[currentGeneration] == maxTokensPerGen) {
            _incrementGeneration();
        }
        uint256 budgetSpent = 0;
        uint256 mintPrice = calculateMintPrice();
        while (budgetLeft >= mintPrice) {
            // L04
            if (generationMintCounts[currentGeneration] == maxTokensPerGen) {
                _incrementGeneration();
                mintPrice = calculateMintPrice();
            }
            _mintInternal(msg.sender, mintPrice);
            amountMinted++;
            budgetLeft -= mintPrice;
            budgetSpent += mintPrice;
            mintPrice = calculateMintPrice();
        }

        if (amountMinted < minAmountMinted) revert TraitForgeNft__NotEnoughTokensMinted(); // M04 L03

        if (budgetLeft > 0) {
            (bool refundSuccess,) = msg.sender.call{ value: budgetLeft }("");
            require(refundSuccess, "Refund failed.");
        }

        if (budgetSpent > 0) _distributeFunds(budgetSpent);

        emit MintedWithBudget(msg.sender, amountMinted, msg.value, budgetLeft); // L03
    }

    //////////////////////////// view functions ////////////////////////////

    function getGeneration() public view returns (uint256) {
        return currentGeneration;
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) public view returns (bool) {
        return _isApprovedOrOwner(spender, tokenId);
    }

    function calculateMintPrice() public view override returns (uint256) {
        // M07
        if (generationMintCounts[currentGeneration] > 0) {
            uint256 currentGenMintCount = generationMintCounts[currentGeneration];
            uint256 priceIncrease = priceIncrement * currentGenMintCount;
            return startPrice + priceIncrease;
        } else {
            return startPrice + ((currentGeneration - 1) * priceIncrementByGen);
        }
    }

    function getTokenEntropy(uint256 tokenId) public view override returns (uint256) {
        require(ownerOf(tokenId) != address(0), "ERC721: query for nonexistent token");
        return tokenEntropy[tokenId];
    }

    function getTokenGeneration(uint256 tokenId) public view override returns (uint256) {
        return tokenGenerations[tokenId];
    }

    function getEntropiesForTokens(
        uint256 forgerTokenId,
        uint256 mergerTokenId
    )
        public
        view
        returns (uint256 forgerEntropy, uint256 mergerEntropy)
    {
        forgerEntropy = getTokenEntropy(forgerTokenId);
        mergerEntropy = getTokenEntropy(mergerTokenId);
    }

    function getTokenLastTransferredTimestamp(uint256 tokenId) public view returns (uint256) {
        require(ownerOf(tokenId) != address(0), "ERC721: query for nonexistent token");
        return lastTokenTransferredTimestamp[tokenId];
    }

    function getTokenCreationTimestamp(uint256 tokenId) public view returns (uint256) {
        require(ownerOf(tokenId) != address(0), "ERC721: query for nonexistent token");
        return tokenCreationTimestamps[tokenId];
    }

    function isForger(uint256 tokenId) public view returns (bool) {
        uint256 entropy = tokenEntropy[tokenId];
        uint256 roleIndicator = entropy % 3;
        return roleIndicator == 0;
    }

    //////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////// internal & private functions ////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////// write functions /////////////////////////////////
    function _mintInternal(address to, uint256 mintPrice) internal returns (uint256) {
        _tokenIds++;
        uint256 newItemId = _tokenIds;
        _mint(to, newItemId);
        IEntropyGenerator entropyGenerator = _getEntropyGenerator();
        uint256 entropyValue = entropyGenerator.nextEntropy();
        tokenCreationTimestamps[newItemId] = block.timestamp;
        while (entropyValue == 999_999 && hasGoldenGodbeenMinted) {
            entropyValue = entropyGenerator.nextEntropy();
        }
        tokenEntropy[newItemId] = entropyValue;
        if (entropyValue == 999_999) {
            hasGoldenGodbeenMinted = true;
        }
        tokenGenerations[newItemId] = currentGeneration;
        generationMintCounts[currentGeneration]++;
        initialOwners[newItemId] = to;

        IAirdrop airdropContract = _getAirdrop();
        if (!airdropContract.airdropStarted()) {
            airdropContract.addUserAmount(to, entropyValue);
        }

        emit Minted(msg.sender, newItemId, currentGeneration, entropyValue, mintPrice);

        return newItemId;
    }

    /// TODO possibility to merge with _mintInternal same logic
    function _mintNewEntity(address newOwner, uint256 entropy, uint256 gen) private returns (uint256) {
        require(generationMintCounts[gen] < maxTokensPerGen, "Exceeds maxTokensPerGen");

        _tokenIds++;
        uint256 newTokenId = _tokenIds;
        _mint(newOwner, newTokenId); // we should respect CEI

        tokenCreationTimestamps[newTokenId] = block.timestamp;
        tokenEntropy[newTokenId] = entropy;
        tokenGenerations[newTokenId] = gen;
        generationMintCounts[gen]++;
        initialOwners[newTokenId] = newOwner;

        // L04
        if (generationMintCounts[gen] == maxTokensPerGen && gen == currentGeneration) {
            _incrementGeneration();
        }

        IAirdrop airdropContract = _getAirdrop();
        if (!airdropContract.airdropStarted()) {
            airdropContract.addUserAmount(newOwner, entropy);
        }

        emit NewEntityMinted(newOwner, newTokenId, gen, entropy);
        return newTokenId;
    }

    function _incrementGeneration() private {
        // Not needed as is the sine qua non of the function and is in private context
        require(generationMintCounts[currentGeneration] == maxTokensPerGen, "Generation limit not yet reached");
        if (currentGeneration == maxGeneration) revert TraitForgeNft__MaxGenerationReached();
        currentGeneration++;
        // require(currentGeneration <= maxGeneration, "Maximum generation reached"); // check not needed
        hasGoldenGodbeenMinted = false;
        priceIncrement += priceIncrementByGen;
        IEntropyGenerator entropyGenerator = _getEntropyGenerator();
        entropyGenerator.initializeAlphaIndices();
        emit GenerationIncremented(currentGeneration);
    }

    // distributes funds to nukeFund contract, where its then distrubted 10% dev 90% nukeFund
    function _distributeFunds(uint256 amount) private {
        require(address(this).balance >= amount, "Insufficient balance");

        address nukeFundAddress = _getNukeFundAddress();
        (bool success,) = nukeFundAddress.call{ value: amount }("");
        require(success, "ETH send failed");

        emit FundsDistributedToNukeFund(nukeFundAddress, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    )
        internal
        virtual
        override
        whenNotPaused // L06
    {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);

        IEntityForging entityForgingContract = _getEntityForging();
        uint256 listedId = entityForgingContract.getListedTokenIds(firstTokenId);
        /// @dev don't update the transferred timestamp if from and to address are same
        if (from != to) {
            lastTokenTransferredTimestamp[firstTokenId] = block.timestamp;
        }

        if (listedId > 0) {
            IEntityForging.Listing memory listing = entityForgingContract.getListings(listedId);
            if (listing.tokenId == firstTokenId && listing.account == from && listing.isListed) {
                entityForgingContract.cancelListingForForging(firstTokenId);
            }
        }
    }

    ///////////////////////////////// view functions /////////////////////////////////

    function getInbredEntropy() internal view returns (uint256) {
        uint256 entropy = 1;
        for (uint256 i = 0; i < 5; i++) {
            uint256 bit = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, i))) % 2;
            entropy = entropy * 10 + bit;
        }
        return entropy;
    }

    function _getEntityForging() private view returns (IEntityForging) {
        return IEntityForging(_addressProvider.getEntityForging());
    }

    function _getEntropyGenerator() private view returns (IEntropyGenerator) {
        return IEntropyGenerator(_addressProvider.getEntropyGenerator());
    }

    function _getAirdrop() private view returns (IAirdrop) {
        return IAirdrop(_addressProvider.getAirdrop());
    }

    function _getNukeFundAddress() private view returns (address) {
        return _addressProvider.getNukeFund();
    }
}

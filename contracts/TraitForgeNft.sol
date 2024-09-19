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
    mapping(uint256 => uint256) public tokenCreationTimestamps;
    mapping(uint256 => uint256) public lastTokenTransferredTimestamp;
    mapping(uint256 => uint256) public tokenEntropy;
    mapping(uint256 => uint256) public generationMintCounts;
    mapping(uint256 => uint256) public tokenGenerations;
    mapping(uint256 => address) public initialOwners;

    uint256 private _tokenIds;
    bool public hasGoldenGodbeenMinted = false;

    modifier onlyWhitelisted(bytes32[] calldata proof, bytes32 leaf) {
        if (block.timestamp <= whitelistEndTime) {
            require(MerkleProof.verify(proof, rootHash, leaf), "Not whitelisted user");
        }
        _;
    }

    constructor(address addressProvider) ERC721("TraitForgeNft", "TFGNFT") AddressProviderResolver(addressProvider) {
        whitelistEndTime = block.timestamp + 24 hours;
    }

    function pause() public onlyProtocolMaintainer {
        _pause();
    }

    function unpause() public onlyProtocolMaintainer {
        _unpause();
    }

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

    function setRootHash(bytes32 rootHash_) external onlyProtocolMaintainer {
        rootHash = rootHash_;
    }

    function setWhitelistEndTime(uint256 endTime_) external onlyProtocolMaintainer {
        whitelistEndTime = endTime_;
    }

    function getGeneration() public view returns (uint256) {
        return currentGeneration;
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) public view returns (bool) {
        return _isApprovedOrOwner(spender, tokenId);
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
        returns (uint256)
    {
        require(msg.sender == address(_getEntityForging()), "unauthorized caller");
        uint256 newGeneration = getTokenGeneration(parent1Id) + 1;

        /// Check new generation is not over maxGeneration
        require(newGeneration <= maxGeneration, "can't be over max generation");

        // Calculate the new entity's entropy
        (uint256 forgerEntropy, uint256 mergerEntropy) = getEntropiesForTokens(parent1Id, parent2Id);
        uint256 newEntropy = (forgerEntropy + mergerEntropy) / 2;

        if (ownerOf(parent1Id) == ownerOf(parent2Id)) {
            newEntropy = getInbredEntropy();
        }
        // Mint the new entity
        uint256 newTokenId = _mintNewEntity(newOwner, newEntropy, newGeneration);

        return newTokenId;
    }

    function mintToken(bytes32[] calldata proof)
        public
        payable
        whenNotPaused
        nonReentrant
        onlyWhitelisted(proof, keccak256(abi.encodePacked(msg.sender)))
    {
        if (generationMintCounts[currentGeneration] >= maxTokensPerGen) {
            _incrementGeneration();
        }
        uint256 mintPrice = calculateMintPrice();
        require(msg.value >= mintPrice, "Insufficient ETH send for minting.");

        _mintInternal(msg.sender, mintPrice);

        uint256 excessPayment = msg.value - mintPrice;
        if (excessPayment > 0) {
            (bool refundSuccess,) = msg.sender.call{ value: excessPayment }("");
            require(refundSuccess, "Refund of excess payment failed.");
        }
    }

    function mintWithBudget(bytes32[] calldata proof)
        public
        payable
        whenNotPaused
        nonReentrant
        onlyWhitelisted(proof, keccak256(abi.encodePacked(msg.sender)))
    {
        uint256 amountMinted = 0;
        uint256 budgetLeft = msg.value;

        if (generationMintCounts[currentGeneration] >= maxTokensPerGen) {
            _incrementGeneration();
        }
        uint256 mintPrice = calculateMintPrice();
        while (budgetLeft >= mintPrice) {
            if (generationMintCounts[currentGeneration] >= maxTokensPerGen) {
                _incrementGeneration();
                mintPrice = calculateMintPrice();
            }
            _mintInternal(msg.sender, mintPrice);
            amountMinted++;
            budgetLeft -= mintPrice;
            mintPrice = calculateMintPrice();
        }
        if (budgetLeft > 0) {
            (bool refundSuccess,) = msg.sender.call{ value: budgetLeft }("");
            require(refundSuccess, "Refund failed.");
        }
    }

    function calculateMintPrice() public view returns (uint256) {
        uint256 currentGenMintCount = generationMintCounts[currentGeneration];
        uint256 priceIncrease = priceIncrement * currentGenMintCount;
        uint256 price = startPrice + priceIncrease;
        return price;
    }

    function getTokenEntropy(uint256 tokenId) public view returns (uint256) {
        require(ownerOf(tokenId) != address(0), "ERC721: query for nonexistent token");
        return tokenEntropy[tokenId];
    }

    function getTokenGeneration(uint256 tokenId) public view returns (uint256) {
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

    function _mintInternal(address to, uint256 mintPrice) internal {
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

        _distributeFunds(mintPrice);
    }

    function _mintNewEntity(address newOwner, uint256 entropy, uint256 gen) private returns (uint256) {
        require(generationMintCounts[gen] < maxTokensPerGen, "Exceeds maxTokensPerGen");

        _tokenIds++;
        uint256 newTokenId = _tokenIds;
        _mint(newOwner, newTokenId);

        tokenCreationTimestamps[newTokenId] = block.timestamp;
        tokenEntropy[newTokenId] = entropy;
        tokenGenerations[newTokenId] = gen;
        generationMintCounts[gen]++;
        initialOwners[newTokenId] = newOwner;

        if (generationMintCounts[gen] >= maxTokensPerGen && gen == currentGeneration) {
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
        require(generationMintCounts[currentGeneration] >= maxTokensPerGen, "Generation limit not yet reached");
        require(currentGeneration < maxGeneration, "Max generation reached");
        currentGeneration++;
        require(currentGeneration <= maxGeneration, "Maximum generation reached");
        hasGoldenGodbeenMinted = false;
        priceIncrement = priceIncrement + priceIncrementByGen;
        IEntropyGenerator entropyGenerator = _getEntropyGenerator();
        entropyGenerator.initializeAlphaIndices();
        emit GenerationIncremented(currentGeneration);
    }

    // distributes funds to nukeFund contract, where its then distrubted 10% dev 90% nukeFund
    function _distributeFunds(uint256 totalAmount) private {
        require(address(this).balance >= totalAmount, "Insufficient balance");

        address nukeFundAddress = _getNukeFundAddress();
        (bool success,) = nukeFundAddress.call{ value: totalAmount }("");
        require(success, "ETH send failed");

        emit FundsDistributedToNukeFund(nukeFundAddress, totalAmount);
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

        require(!paused(), "ERC721Pausable: token transfer while paused");
    }

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

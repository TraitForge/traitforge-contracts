// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";
import {INukeFund} from "./interfaces/INukeFund.sol";
import {ITraitForgeNft} from "./interfaces/ITraitForgeNft.sol";
import {IAirdrop} from "./interfaces/IAirdrop.sol";

contract NukeFund is INukeFund, ReentrancyGuard, Ownable, Pausable {
    // Type declarations

    // State variables
    uint256 public constant MAX_DENOMINATOR = 100000;

    uint256 private fund;
    ITraitForgeNft public nftContract;
    IAirdrop public airdropContract;
    address payable public devAddress;
    address payable public daoAddress;
    uint256 private constant BPS = 10_000; // denominator of basis points
    uint256 public taxCut = 1000; //10%
    uint256 public defaultNukeFactorIncrease = 12500; //12.5%
    uint256 public maxAllowedClaimDivisor = 2;
    uint256 public nukeFactorMaxParam = MAX_DENOMINATOR / 2;
    uint256 public minimumDaysHeld = 3 days;

    // Events

    // Errors
    error NukeFund__TaxCutExceedsLimit();
    error NukeFund__TokenOwnerIsAddressZero();
    error NukeFund__CallerNotTokenOwner();
    error NukeFund__ContractNotApproved();
    error NukeFund__TokenNotMature();

    // Modifiers

    // Functions

    // Constructor now properly passes the initial owner address to the Ownable constructor
    constructor(address _traitForgeNft, address _airdrop, address payable _devAddress, address payable _daoAddress) {
        nftContract = ITraitForgeNft(_traitForgeNft);
        airdropContract = IAirdrop(_airdrop);
        devAddress = _devAddress; // Set the developer's address
        daoAddress = _daoAddress;
    }

    // Fallback function to receive ETH and update fund balance
    receive() external payable {
        uint256 devShare = (msg.value * taxCut) / BPS; // Calculate developer's share (10%)
        uint256 remainingFund = msg.value - devShare; // Calculate remaining funds to add to the fund

        fund += remainingFund; // Update the fund balance

        if (!airdropContract.airdropStarted()) {
            (bool success,) = devAddress.call{value: devShare}("");
            require(success, "ETH send failed");
            emit DevShareDistributed(devShare);
        } else if (!airdropContract.daoFundAllowed()) {
            (bool success,) = payable(owner()).call{value: devShare}("");
            require(success, "ETH send failed");
        } else {
            (bool success,) = daoAddress.call{value: devShare}("");
            require(success, "ETH send failed");
            emit DevShareDistributed(devShare);
        }

        emit FundReceived(msg.sender, msg.value); // Log the received funds
        emit FundBalanceUpdated(fund); // Update the fund balance
    }

    function nuke(uint256 tokenId) public whenNotPaused nonReentrant {
        if (nftContract.ownerOf(tokenId) != msg.sender) revert NukeFund__CallerNotTokenOwner();
        if (
            !(
                nftContract.getApproved(tokenId) == address(this)
                    || nftContract.isApprovedForAll(msg.sender, address(this))
            )
        ) revert NukeFund__ContractNotApproved();
        if (!canTokenBeNuked(tokenId)) revert NukeFund__TokenNotMature();

        uint256 finalNukeFactor = calculateNukeFactor(tokenId); // finalNukeFactor has 5 digits
        uint256 potentialClaimAmount = (fund * finalNukeFactor) / MAX_DENOMINATOR; // Calculate the potential claim amount based on the finalNukeFactor
        uint256 maxAllowedClaimAmount = fund / maxAllowedClaimDivisor; // Define a maximum allowed claim amount as 50% of the current fund size

        // Directly assign the value to claimAmount based on the condition, removing the redeclaration
        uint256 claimAmount = finalNukeFactor > nukeFactorMaxParam ? maxAllowedClaimAmount : potentialClaimAmount;

        fund -= claimAmount; // Deduct the claim amount from the fund

        nftContract.burn(tokenId); // Burn the token
        (bool success,) = payable(msg.sender).call{value: claimAmount}("");
        require(success, "Failed to send Ether");

        emit Nuked(msg.sender, tokenId, claimAmount); // Emit the event with the actual claim amount
        emit FundBalanceUpdated(fund); // Update the fund balance
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function setTaxCut(uint256 _taxCut) external onlyOwner {
        if (_taxCut > BPS) revert NukeFund__TaxCutExceedsLimit();
        taxCut = _taxCut;
    }

    function setMinimumDaysHeld(uint256 value) external onlyOwner {
        minimumDaysHeld = value;
    }

    function setDefaultNukeFactorIncrease(uint256 value) external onlyOwner {
        defaultNukeFactorIncrease = value;
    }

    function setMaxAllowedClaimDivisor(uint256 value) external onlyOwner {
        maxAllowedClaimDivisor = value;
    }

    function setNukeFactorMaxParam(uint256 value) external onlyOwner {
        nukeFactorMaxParam = value;
    }

    // Allow the owner to update the reference to the ERC721 contract
    function setTraitForgeNftContract(address _traitForgeNft) external onlyOwner {
        nftContract = ITraitForgeNft(_traitForgeNft);
        emit TraitForgeNftAddressUpdated(_traitForgeNft); // Emit an event when the address is updated.
    }

    function setAirdropContract(address _airdrop) external onlyOwner {
        airdropContract = IAirdrop(_airdrop);
        emit AirdropAddressUpdated(_airdrop); // Emit an event when the address is updated.
    }

    function setDevAddress(address payable account) external onlyOwner {
        devAddress = account;
        emit DevAddressUpdated(account);
    }

    function setDaoAddress(address payable account) external onlyOwner {
        daoAddress = account;
        emit DaoAddressUpdated(account);
    }

    // View function to see the current balance of the fund
    function getFundBalance() public view returns (uint256) {
        return fund;
    }

    // Calculate the age of a token based on its creation timestamp and current time
    function calculateAge(uint256 tokenId) public view returns (uint256) {
        if (nftContract.ownerOf(tokenId) == address(0)) revert NukeFund__TokenOwnerIsAddressZero();

        uint256 perfomanceFactor = nftContract.getTokenEntropy(tokenId) % 10;

        uint256 age = (
            perfomanceFactor * MAX_DENOMINATOR * (block.timestamp - nftContract.getTokenCreationTimestamp(tokenId))
                / (60 * 60 * 24 * 365)
        );
        return age;
    }

    // Calculate the nuke factor of a token, which affects the claimable amount from the fund
    function calculateNukeFactor(uint256 tokenId) public view returns (uint256) {
        if (nftContract.ownerOf(tokenId) == address(0)) revert NukeFund__TokenOwnerIsAddressZero();

        uint256 entropy = nftContract.getTokenEntropy(tokenId);
        uint256 adjustedAge = calculateAge(tokenId);

        uint256 initialNukeFactor = entropy / 40; // calcualte initalNukeFactor based on entropy, 5 digits

        uint256 finalNukeFactor = ((adjustedAge * defaultNukeFactorIncrease) / MAX_DENOMINATOR) + initialNukeFactor; // CONSIDER USING DYNAMIC INCREASE BY ENTROPY INSTEAD OF DEFAULT

        return finalNukeFactor;
    }

    function canTokenBeNuked(uint256 tokenId) public view returns (bool) {
        // Ensure the token exists
        if (nftContract.ownerOf(tokenId) == address(0)) revert NukeFund__TokenOwnerIsAddressZero();
        uint256 tokenAgeInSeconds = block.timestamp - nftContract.getTokenLastTransferredTimestamp(tokenId);
        // Assuming tokenAgeInSeconds is the age of the token since it's holding the nft, check if it's over minimum days held
        return tokenAgeInSeconds >= minimumDaysHeld;
    }
}
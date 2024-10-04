// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { INukeFund } from "contracts/interfaces/INukeFund.sol";
import { ITraitForgeNft } from "contracts/interfaces/ITraitForgeNft.sol";
import { IAirdrop } from "contracts/interfaces/IAirdrop.sol";
import { AddressProviderResolver } from "contracts/core/AddressProviderResolver.sol";

contract NukeFund is INukeFund, AddressProviderResolver, ReentrancyGuard, Pausable {
    // Type declarations

    // State variables
    uint256 public constant MAX_DENOMINATOR = 100_000;
    uint256 private fund;
    uint256 private constant BPS = 10_000; // denominator of basis points
    uint256 public taxCut = 1000; //10%
    uint256 public defaultNukeFactorIncrease = 12_500; //12.5%
    uint256 public maxAllowedClaimDivisor = 2;
    uint256 public nukeFactorMaxParam = MAX_DENOMINATOR / 2;
    uint256 public minimumDaysHeld = 3 days;
    address public ethCollector;
    uint256 public initNukeFactorDivisor = 100;

    uint256 public unpauseAt;
    uint256 public empDivisor = 10;
    bool public isEMPActive = false;

    // Events

    // Errors
    error NukeFund__TaxCutExceedsLimit();
    error NukeFund__TokenOwnerIsAddressZero();
    error NukeFund__CallerNotTokenOwner();
    error NukeFund__ContractNotApproved();
    error NukeFund__TokenNotMature();
    error NukeFund__AddressIsZero();
    error NukeFund__DivisorIsZero();
    error NukeFund__EmpIsActive();

    // Modifiers

    // Functions

    // Constructor now properly passes the initial owner address to the Ownable constructor
    constructor(address addressProvider, address _ethCollector) AddressProviderResolver(addressProvider) {
        if (_ethCollector == address(0)) revert NukeFund__AddressIsZero();
        ethCollector = _ethCollector;
    }

    // Fallback function to receive ETH and update fund balance
    receive() external payable {
        uint256 devShare = (msg.value * taxCut) / BPS; // Calculate developer's share (10%)
        uint256 remainingFund = msg.value - devShare; // Calculate remaining funds to add to the fund

        fund += remainingFund; // Update the fund balance
        IAirdrop airdropContract = _getAirdrop();
        address devAddress = payable(_getDevFundAddress());
        address daoAddress = payable(_getDaoFundAddress());

        if (!airdropContract.airdropStarted()) {
            (bool success,) = devAddress.call{ value: devShare }("");
            require(success, "ETH send failed");
            emit DevShareDistributed(devShare);
        } else if (!airdropContract.daoFundAllowed()) {
            (bool success,) = payable(ethCollector).call{ value: devShare }("");
            require(success, "ETH send failed");
        } else {
            (bool success,) = daoAddress.call{ value: devShare }("");
            require(success, "ETH send failed");
            emit DevShareDistributed(devShare);
        }

        emit FundReceived(msg.sender, msg.value); // Log the received funds
        emit FundBalanceUpdated(fund); // Update the fund balance
    }

    function nuke(uint256 tokenId) public whenNotPaused nonReentrant {
        if (isEMPActive) {
            if (block.number < unpauseAt) revert NukeFund__EmpIsActive();
            isEMPActive = false;
        }
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        if (traitForgeNft.ownerOf(tokenId) != msg.sender) revert NukeFund__CallerNotTokenOwner();
        if (
            !(
                traitForgeNft.getApproved(tokenId) == address(this)
                    || traitForgeNft.isApprovedForAll(msg.sender, address(this))
            )
        ) revert NukeFund__ContractNotApproved();
        if (!canTokenBeNuked(tokenId)) revert NukeFund__TokenNotMature();

        uint256 finalNukeFactor = calculateNukeFactor(tokenId); // finalNukeFactor has 5 digits
        uint256 potentialClaimAmount = (fund * finalNukeFactor) / MAX_DENOMINATOR; // Calculate the potential claim
            // amount based on the finalNukeFactor
        uint256 maxAllowedClaimAmount = fund / maxAllowedClaimDivisor; // Define a maximum allowed claim amount as 50%
            // of the current fund size

        // Directly assign the value to claimAmount based on the condition, removing the redeclaration
        uint256 claimAmount = finalNukeFactor > nukeFactorMaxParam ? maxAllowedClaimAmount : potentialClaimAmount;

        fund -= claimAmount; // Deduct the claim amount from the fund

        _activateEmpIfNeeded(tokenId);
        traitForgeNft.burn(tokenId); // Burn the token
        (bool success,) = payable(msg.sender).call{ value: claimAmount }("");
        require(success, "Failed to send Ether");

        emit Nuked(msg.sender, tokenId, claimAmount); // Emit the event with the actual claim amount
        emit FundBalanceUpdated(fund); // Update the fund balance
    }

    function pause() public onlyProtocolMaintainer {
        _pause();
    }

    function unpause() public onlyProtocolMaintainer {
        _unpause();
    }

    function setTaxCut(uint256 _taxCut) external onlyProtocolMaintainer {
        if (_taxCut > BPS) revert NukeFund__TaxCutExceedsLimit();
        taxCut = _taxCut;
    }

    function setMinimumDaysHeld(uint256 value) external onlyProtocolMaintainer {
        minimumDaysHeld = value;
    }

    function setDefaultNukeFactorIncrease(uint256 value) external onlyProtocolMaintainer {
        defaultNukeFactorIncrease = value;
    }

    function setMaxAllowedClaimDivisor(uint256 value) external onlyProtocolMaintainer {
        maxAllowedClaimDivisor = value;
    }

    function setNukeFactorMaxParam(uint256 value) external onlyProtocolMaintainer {
        nukeFactorMaxParam = value;
    }

    function setInitNukeFactorDivisor(uint256 value) external onlyProtocolMaintainer {
        if (value == 0) revert NukeFund__DivisorIsZero();
        initNukeFactorDivisor = value;
    }

    function setEmpDivisor(uint256 value) external onlyProtocolMaintainer {
        if (value == 0) revert NukeFund__DivisorIsZero();
        empDivisor = value;
    }

    // View function to see the current balance of the fund
    function getFundBalance() public view returns (uint256) {
        return fund;
    }

    // Calculate the age of a token based on its creation timestamp and current time
    function calculateAge(uint256 tokenId) public view returns (uint256) {
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        if (traitForgeNft.ownerOf(tokenId) == address(0)) revert NukeFund__TokenOwnerIsAddressZero();

        uint256 perfomanceFactor = traitForgeNft.getTokenEntropy(tokenId) % 10;

        uint256 age = (
            perfomanceFactor * MAX_DENOMINATOR * (block.timestamp - traitForgeNft.getTokenCreationTimestamp(tokenId))
                / (60 * 60 * 24 * 365)
        );
        return age;
    }

    // Calculate the nuke factor of a token, which affects the claimable amount from the fund
    function calculateNukeFactor(uint256 tokenId) public view returns (uint256) {
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        if (traitForgeNft.ownerOf(tokenId) == address(0)) revert NukeFund__TokenOwnerIsAddressZero();

        uint256 entropy = traitForgeNft.getTokenEntropy(tokenId);
        uint256 adjustedAge = calculateAge(tokenId);

        uint256 initialNukeFactor = entropy / initNukeFactorDivisor; // calcualte initalNukeFactor based on entropy, 5
            // digits

        uint256 finalNukeFactor = ((adjustedAge * defaultNukeFactorIncrease) / MAX_DENOMINATOR) + initialNukeFactor; // CONSIDER
            // USING DYNAMIC INCREASE BY ENTROPY INSTEAD OF DEFAULT

        return finalNukeFactor;
    }

    function canTokenBeNuked(uint256 tokenId) public view returns (bool) {
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        // Ensure the token exists
        if (traitForgeNft.ownerOf(tokenId) == address(0)) revert NukeFund__TokenOwnerIsAddressZero();
        uint256 tokenAgeInSeconds = block.timestamp - traitForgeNft.getTokenLastTransferredTimestamp(tokenId);
        // Assuming tokenAgeInSeconds is the age of the token since it's holding the nft, check if it's over minimum
        // days held
        return tokenAgeInSeconds >= minimumDaysHeld;
    }

    function _activateEmpIfNeeded(uint256 tokenId) private {
        uint256 entropy = _getTraitForgeNft().getTokenEntropy(tokenId);
        if (entropy % 10 == 7) {
            isEMPActive = true; // sets EMPActive to true if the token is an emp
            unpauseAt = block.number + (entropy / empDivisor); // sets the end index of pause
            emit EmpActivated(tokenId, unpauseAt);
        }
    }

    function _getDevFundAddress() private view returns (address) {
        return _addressProvider.getDevFund();
    }

    function _getDaoFundAddress() private view returns (address) {
        return _addressProvider.getDAOFund();
    }

    function _getTraitForgeNft() private view returns (ITraitForgeNft) {
        return ITraitForgeNft(_addressProvider.getTraitForgeNft());
    }

    function _getAirdrop() private view returns (IAirdrop) {
        return IAirdrop(_addressProvider.getAirdrop());
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { ITraitForgeNft } from "./interfaces/ITraitForgeNft.sol";
import { IEntityForging } from "./interfaces/IEntityForging.sol";
import { AddressProviderResolver } from "contracts/core/AddressProviderResolver.sol";

contract EntityForging is IEntityForging, AddressProviderResolver, ReentrancyGuard, Pausable {
    // Type declarations

    // Events

    // Modifiers

    // State variables
    uint256 public taxCut = 1000; //10%
    uint256 private constant BPS = 10_000; // denominator of basis points
    uint256 public oneYearInDays = 365 days;
    uint256 public listingCount = 0;

    /// @dev tokenid -> listings index
    mapping(uint256 => uint256) public listedTokenIds;
    mapping(uint256 => mapping(uint256 => bool)) public forgedPairs; //innefficient
    /// @dev index -> listing info
    mapping(uint256 => Listing) public listings;
    mapping(uint256 => uint8) public forgingCounts; // track forgePotential
    mapping(uint256 => uint256) public lastForgeResetTimestamp;

    //Errors
    error EntityForging__OffsetOutOfBounds();
    error EntityForging__TokenAlreadyListed();
    error EntityForging__TokenNotOwnedByCaller();
    error EntityForging__FeeTooLow();
    error EntityForging__NotForger();
    error EntityForging__MergerTokenIdIsZero();
    error EntityForging__ForgerTokenIdNotListed();
    error EntityForging__MergerTokenNotOwnedByCaller();
    error EntityForging__TokensNotSameGeneration();
    error EntityForging__TokensAlreadyForged();
    error EntityForging__FeeMismatchWithEthSent();
    error EntityForging__MergerEntropyCannotMerge();
    error EntityForging__InsufficientForgerForgePotential();
    error EntityForging__InsufficientMergerForgePotential();
    error EntityForging__TokenNotListedForForging(uint256 tokenId);

    // Functions

    constructor(address _addressProvider) AddressProviderResolver(_addressProvider) { }

    /**
     * external & public functions *******************************
     */

    //////////////////////////// write functions ////////////////////////////

    function pause() public onlyProtocolMaintainer {
        _pause();
    }

    function unpause() public onlyProtocolMaintainer {
        _unpause();
    }

    function setTaxCut(uint256 _taxCut) external onlyProtocolMaintainer {
        require(_taxCut <= BPS, "Tax cut cannot exceed 100%");
        taxCut = _taxCut;
    }

    function setOneYearInDays(uint256 value) external onlyProtocolMaintainer {
        oneYearInDays = value;
    }

    function listForForging(uint256 tokenId, uint256 fee) public whenNotPaused nonReentrant {
        Listing memory _listingInfo = listings[listedTokenIds[tokenId]];
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        if (_listingInfo.isListed) revert EntityForging__TokenAlreadyListed();
        if (traitForgeNft.ownerOf(tokenId) != msg.sender) revert EntityForging__TokenNotOwnedByCaller();
        if (fee < traitForgeNft.calculateMintPrice()) revert EntityForging__FeeTooLow();

        _resetForgingCountIfNeeded(tokenId);

        uint256 entropy = traitForgeNft.getTokenEntropy(tokenId); // Retrieve entropy for tokenId

        bool isForger = (entropy % 3) == 0; // Determine if the token is a forger need to keep the logic somewhere else
        if (!isForger) revert EntityForging__NotForger();

        uint8 forgePotential = uint8((entropy / 10) % 10); // Extract the 5th digit from the entropy
        if (!(forgePotential > 0 && forgingCounts[tokenId] < forgePotential)) {
            revert EntityForging__InsufficientForgerForgePotential();
        }

        ++listingCount;
        listings[listingCount] = Listing(msg.sender, tokenId, true, fee);
        listedTokenIds[tokenId] = listingCount;

        emit ListedForForging(tokenId, fee);
    }

    function forgeWithListed(
        uint256 forgerTokenId,
        uint256 mergerTokenId
    )
        external
        payable
        whenNotPaused
        nonReentrant
        returns (uint256)
    {
        Listing memory _forgerListingInfo = listings[listedTokenIds[forgerTokenId]];
        _forgePreGuards(forgerTokenId, mergerTokenId, _forgerListingInfo.isListed);
        if (msg.value != _forgerListingInfo.fee) revert EntityForging__FeeMismatchWithEthSent();

        uint256 lowerId = _lowerId(forgerTokenId, mergerTokenId);
        uint256 higherId = _higherId(forgerTokenId, mergerTokenId); //innefficient
        if (forgedPairs[lowerId][higherId]) revert EntityForging__TokensAlreadyForged();

        uint256 forgerId = forgerTokenId;
        uint256 mergerId = mergerTokenId;
        _resetForgingCountIfNeeded(forgerId); // Reset for forger if needed
        _resetForgingCountIfNeeded(mergerId); // Reset for merger if needed

        // Check forger's breed count increment but do not check forge potential here
        // as it is already checked in listForForging for the forger
        forgingCounts[forgerId]++;

        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        // Check and update for merger token's forge potential
        uint256 mergerEntropy = traitForgeNft.getTokenEntropy(mergerId);
        if (!(mergerEntropy % 3 != 0)) revert EntityForging__MergerEntropyCannotMerge();
        uint8 mergerForgePotential = uint8((mergerEntropy / 10) % 10); // Extract the 5th digit from the entropy
        forgingCounts[mergerId]++;
        if (!(mergerForgePotential > 0 && forgingCounts[mergerId] <= mergerForgePotential)) {
            revert EntityForging__InsufficientMergerForgePotential();
        }
        uint256 forgerEntropy = traitForgeNft.getTokenEntropy(forgerTokenId);
        if ((forgerEntropy % 10) == 2) {
            forgingCounts[mergerId] = 0;
        }
        /// TODO Stack too deep
        // uint256 devShare = (msg.value * taxCut) / BPS;
        // uint256 forgingFee = _forgerListingInfo.fee;
        // uint256 forgerShare = forgingFee - devShare;
        // address payable forgerOwner = payable(traitForgeNft.ownerOf(forgerId));
        // (bool success,) = nukeFundAddress.call{ value: devShare }("");
        // require(success, "Failed to send to NukeFund");
        // (bool success_forge,) = forgerOwner.call{ value: forgerShare }("");
        // require(success_forge, "Failed to send to Forge Owner");

        _processTransferShares(forgerId, _forgerListingInfo.fee, traitForgeNft);

        uint256 newTokenId = traitForgeNft.forge(msg.sender, forgerId, mergerId, "");
        forgedPairs[lowerId][higherId] = true;

        // Cancel listed forger nft
        _cancelListingForForging(forgerId);

        uint256 newEntropy = traitForgeNft.getTokenEntropy(newTokenId);

        emit EntityForged(newTokenId, forgerId, mergerId, newEntropy, _forgerListingInfo.fee);

        return newTokenId;
    }

    function cancelListingForForging(uint256 tokenId) external whenNotPaused nonReentrant {
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        if (!(traitForgeNft.ownerOf(tokenId) == msg.sender || msg.sender == address(traitForgeNft))) {
            revert EntityForging__TokenNotOwnedByCaller();
        }
        if (!listings[listedTokenIds[tokenId]].isListed) revert EntityForging__TokenNotListedForForging(tokenId);

        _cancelListingForForging(tokenId);
    }

    function migrateListingData(
        Listing[] memory _listings,
        uint256 startIndex,
        uint256 endIndex,
        uint256 _listingCount
    )
        external
        onlyProtocolMaintainer
    {
        if (endIndex > _listings.length) {
            revert EntityForging__OffsetOutOfBounds();
        }
        if (startIndex > endIndex) {
            revert EntityForging__OffsetOutOfBounds();
        }
        for (uint256 i = startIndex; i < endIndex; i++) {
            listings[startIndex + i + 1] = _listings[i];
            listedTokenIds[_listings[i].tokenId] = startIndex + i + 1;
        }
        listingCount = _listingCount;
    }

    function migrateForgedPairsData(
        uint256[] memory lowerIds,
        uint256[] memory higherIds
    )
        external
        onlyProtocolMaintainer
    {
        require(lowerIds.length == higherIds.length, "Array length mismatch");
        for (uint256 i = 0; i < lowerIds.length; i++) {
            forgedPairs[lowerIds[i]][higherIds[i]] = true;
            forgingCounts[lowerIds[i]]++;
            forgingCounts[higherIds[i]]++;
        }
    }
    //////////////////////////// read functions ////////////////////////////

    function fetchListings(uint256 offset, uint256 limit) external view returns (Listing[] memory _listings) {
        // L07
        if (offset >= listingCount) {
            revert EntityForging__OffsetOutOfBounds();
        }

        uint256 end = offset + limit;
        if (end > listingCount) end = listingCount;
        uint256 resultCount = end - offset;

        _listings = new Listing[](resultCount);
        for (uint256 i = 0; i < resultCount; ++i) {
            _listings[i] = listings[offset + i + 1];
        }
    }

    function getListedTokenIds(uint256 tokenId_) external view override returns (uint256) {
        return listedTokenIds[tokenId_];
    }

    function getListings(uint256 id) external view override returns (Listing memory) {
        return listings[id];
    }

    function getListingForTokenId(uint256 tokenId) external view returns (Listing memory) {
        return listings[listedTokenIds[tokenId]];
    }

    /**
     * internal & private *******************************************
     */
    function _getTraitForgeNft() private view returns (ITraitForgeNft) {
        return ITraitForgeNft(_addressProvider.getTraitForgeNft());
    }

    function _cancelListingForForging(uint256 tokenId) internal {
        delete listings[listedTokenIds[tokenId]];

        emit CancelledListingForForging(tokenId); // Emitting with 0 fee to denote cancellation
    }

    function _resetForgingCountIfNeeded(uint256 tokenId) private {
        uint256 oneYear = oneYearInDays;
        if (lastForgeResetTimestamp[tokenId] == 0) {
            lastForgeResetTimestamp[tokenId] = block.timestamp;
        } else if (block.timestamp >= lastForgeResetTimestamp[tokenId] + oneYear) {
            forgingCounts[tokenId] = 0; // Reset to the forge potential
            lastForgeResetTimestamp[tokenId] = block.timestamp;
        }
    }

    function _processTransferShares(uint256 forgerId, uint256 forgingFee, ITraitForgeNft traitForgeNft) private {
        uint256 devShare = (forgingFee * taxCut) / BPS;
        uint256 forgerShare = forgingFee - devShare;

        (bool success,) = payable(_getNukeFundAddress()).call{ value: devShare }("");
        require(success, "Failed to send to NukeFund");

        address payable forgerOwner = payable(traitForgeNft.ownerOf(forgerId));
        (bool success_forge,) = forgerOwner.call{ value: forgerShare }("");
        require(success_forge, "Failed to send to Forge Owner");
    }

    function _forgePreGuards(uint256 forgerTokenId, uint256 mergerTokenId, bool forgerTokenIdIsListed) private view {
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        if (!forgerTokenIdIsListed) revert EntityForging__ForgerTokenIdNotListed();
        if (mergerTokenId == 0) revert EntityForging__MergerTokenIdIsZero();
        if (traitForgeNft.ownerOf(mergerTokenId) != msg.sender) revert EntityForging__MergerTokenNotOwnedByCaller();
        if (traitForgeNft.getTokenGeneration(mergerTokenId) != traitForgeNft.getTokenGeneration(forgerTokenId)) {
            revert EntityForging__TokensNotSameGeneration();
        }
    }

    function _lowerId(uint256 tokenId1, uint256 tokenId2) private pure returns (uint256) {
        return tokenId1 < tokenId2 ? tokenId1 : tokenId2;
    }

    function _higherId(uint256 tokenId1, uint256 tokenId2) private pure returns (uint256) {
        return tokenId1 < tokenId2 ? tokenId2 : tokenId1;
    }

    function _getNukeFundAddress() private view returns (address) {
        return _addressProvider.getNukeFund();
    }
}

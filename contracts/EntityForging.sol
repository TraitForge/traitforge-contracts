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
    address payable public nukeFundAddress;
    uint256 public taxCut = 1000; //10%
    uint256 private constant BPS = 10_000; // denominator of basis points
    uint256 public oneYearInDays = 365 days;
    uint256 public listingCount = 0;
    uint256 public minimumListFee = 0.01 ether;

    /// @dev tokenid -> listings index
    mapping(uint256 => uint256) public listedTokenIds;
    mapping(uint256 => mapping(uint256 => bool)) private forgedPairs; //innefficient
    /// @dev index -> listing info
    mapping(uint256 => Listing) public listings;
    mapping(uint256 => uint8) public forgingCounts; // track forgePotential
    mapping(uint256 => uint256) private lastForgeResetTimestamp;

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

    function setMinimumListingFee(uint256 _fee) external onlyProtocolMaintainer {
        minimumListFee = _fee;
    }

    function listForForging(uint256 tokenId, uint256 fee) public whenNotPaused nonReentrant {
        Listing memory _listingInfo = listings[listedTokenIds[tokenId]];
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        require(!_listingInfo.isListed, "Token is already listed for forging");
        require(traitForgeNft.ownerOf(tokenId) == msg.sender, "Caller must own the token");
        require(fee >= minimumListFee, "Fee should be higher than minimum listing fee");

        _resetForgingCountIfNeeded(tokenId);

        uint256 entropy = traitForgeNft.getTokenEntropy(tokenId); // Retrieve entropy for tokenId
        uint8 forgePotential = uint8((entropy / 10) % 10); // Extract the 5th digit from the entropy
        require(forgePotential > 0 && forgingCounts[tokenId] < forgePotential, "Entity has reached its forging limit");

        bool isForger = (entropy % 3) == 0; // Determine if the token is a forger based on entropy
        require(isForger, "Only forgers can list for forging");

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
        _forgePreGuards(forgerTokenId, mergerTokenId, _forgerListingInfo);

        uint256 lowerId = _lowerId(forgerTokenId, mergerTokenId);
        uint256 higherId = _higherId(forgerTokenId, mergerTokenId); //innefficient
        require(!forgedPairs[lowerId][higherId], "Parents have forged before");

        uint256 forgerId = forgerTokenId;
        uint256 mergerId = mergerTokenId;
        require(msg.value == _forgerListingInfo.fee, "Fee cannot be less than or more than msg.value");

        _resetForgingCountIfNeeded(forgerId); // Reset for forger if needed
        _resetForgingCountIfNeeded(mergerId); // Reset for merger if needed

        // Check forger's breed count increment but do not check forge potential here
        // as it is already checked in listForForging for the forger
        forgingCounts[forgerId]++;

        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        // Check and update for merger token's forge potential
        uint256 mergerEntropy = traitForgeNft.getTokenEntropy(mergerId);
        require(mergerEntropy % 3 != 0, "Not merger");
        uint8 mergerForgePotential = uint8((mergerEntropy / 10) % 10); // Extract the 5th digit from the entropy
        forgingCounts[mergerId]++;
        require(
            mergerForgePotential > 0 && forgingCounts[mergerId] <= mergerForgePotential, "forgePotential insufficient"
        );

        // uint256 devShare = (msg.value * taxCut) / BPS;
        // uint256 forgingFee = _forgerListingInfo.fee;
        // uint256 forgerShare = forgingFee - devShare;
        // address payable forgerOwner = payable(traitForgeNft.ownerOf(forgerId));
        // (bool success,) = nukeFundAddress.call{ value: devShare }("");
        // require(success, "Failed to send to NukeFund");
        // (bool success_forge,) = forgerOwner.call{ value: forgerShare }("");
        // require(success_forge, "Failed to send to Forge Owner");

        _processFees(forgerId, _forgerListingInfo.fee, msg.value, traitForgeNft);

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
        require(
            traitForgeNft.ownerOf(tokenId) == msg.sender || msg.sender == address(traitForgeNft),
            "Caller must own the token"
        );
        require(listings[listedTokenIds[tokenId]].isListed, "Token not listed for forging");

        _cancelListingForForging(tokenId);
    }

    //////////////////////////// read functions ////////////////////////////

    function fetchListings() external view returns (Listing[] memory _listings) {
        _listings = new Listing[](listingCount + 1);
        for (uint256 i = 1; i <= listingCount; ++i) {
            _listings[i] = listings[i];
        }
    }

    function getListedTokenIds(uint256 tokenId_) external view override returns (uint256) {
        return listedTokenIds[tokenId_];
    }

    function getListings(uint256 id) external view override returns (Listing memory) {
        return listings[id];
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

    function _processFees(
        uint256 forgerId,
        uint256 forgingFee,
        uint256 msgValue,
        ITraitForgeNft traitForgeNft
    )
        private
    {
        uint256 devShare = (msgValue * taxCut) / BPS;
        uint256 forgerShare = forgingFee - devShare;

        (bool success,) = nukeFundAddress.call{ value: devShare }("");
        require(success, "Failed to send to NukeFund");

        address payable forgerOwner = payable(traitForgeNft.ownerOf(forgerId));
        (bool success_forge,) = forgerOwner.call{ value: forgerShare }("");
        require(success_forge, "Failed to send to Forge Owner");
    }

    function _forgePreGuards(
        uint256 forgerTokenId,
        uint256 mergerTokenId,
        Listing memory _forgerListingInfo
    )
        private
        view
    {
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        require(_forgerListingInfo.isListed, "Forger's entity not listed for forging");
        require(forgerTokenId != 0 && mergerTokenId != 0, "Invalid token ID: Token ID cannot be 0");
        require(traitForgeNft.ownerOf(mergerTokenId) == msg.sender, "Caller must own the merger token");
        require(
            traitForgeNft.getTokenGeneration(mergerTokenId) == traitForgeNft.getTokenGeneration(forgerTokenId),
            "Invalid token generation"
        );
    }

    function _lowerId(uint256 tokenId1, uint256 tokenId2) private pure returns (uint256) {
        return tokenId1 < tokenId2 ? tokenId1 : tokenId2;
    }

    function _higherId(uint256 tokenId1, uint256 tokenId2) private pure returns (uint256) {
        return tokenId1 < tokenId2 ? tokenId2 : tokenId1;
    }
}

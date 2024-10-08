// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IEntityForging {
    struct Listing {
        address account;
        uint256 tokenId;
        bool isListed;
        uint256 fee;
    }

    event ListedForForging(uint256 tokenId, uint256 fee);
    event EntityForged(
        uint256 indexed newTokenid,
        uint256 indexed parent1Id,
        uint256 indexed parent2Id,
        uint256 newEntropy,
        uint256 forgingFee
    );
    event CancelledListingForForging(uint256 tokenId);

    function setTaxCut(uint256 _taxCut) external;

    function setOneYearInDays(uint256 value) external;

    function listForForging(uint256 tokenId, uint256 fee) external;

    function forgeWithListed(uint256 forgerTokenId, uint256 mergerTokenId) external payable returns (uint256);

    function cancelListingForForging(uint256 tokenId) external;

    function fetchListings(uint256 offset, uint256 limit) external view returns (Listing[] memory);
    function getListedTokenIds(uint256 tokenId_) external view returns (uint256);
    function getListings(uint256 id) external view returns (Listing memory);
}

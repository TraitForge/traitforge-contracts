// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IEntropyGenerator {
    event EntropyRetrieved(uint256 indexed entropy);

    // function to retrieve the next entropy value, accessible only by the allowed caller
    function nextEntropy() external returns (uint256);

    // public function to expose entropy calculation for a given slot and number index
    function getPublicEntropy(uint256 slotIndex, uint256 numberIndex) external view returns (uint256);

    // function to get the last initialized index for debugging or informational puroposed
    function getLastInitializedIndex() external view returns (uint256);

    function initializeAlphaIndices() external;
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IEntropyGenerator {
  event AllowedCallerUpdated(address allowedCaller);
  event EntropyRetrieved(uint256 indexed entropy);

  // Function to update the allowed caller, restricted to the owner of the contract
  function setAllowedCaller(address _allowedCaller) external;

  // function to get the current allowed caller
  function getAllowedCaller() external view returns (address);

  // Functions to initalize entropy values inbatches to spread gas cost over multiple transcations
  function writeEntropyBatch() external;

  // function to retrieve the next entropy value, accessible only by the allowed caller
  function getNextEntropy() external returns (uint256);

  // public function to expose entropy calculation for a given slot and number index
  function getPublicEntropy(
    uint256 slotIndex,
    uint256 numberIndex
  ) external view returns (uint256);

  // function to get the last initialized index for debugging or informational puroposed
  function getLastInitializedIndex() external view returns (uint256);

  function initializeAlphaIndices() external;
}

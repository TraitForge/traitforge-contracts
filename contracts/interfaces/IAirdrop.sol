// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAirdrop {
  /**
   * @notice Set the trait token address
   * @param _traitToken The address of the trait token
   */
  function setTraitToken(address _traitToken) external;

  /**
   * @notice Start the airdrop
   * @param amount The amount of trait token to be airdropped
   */
  function startAirdrop(uint256 amount) external;

  /**
   * @notice Allow DAO fund to claim the airdrop
   */
  function airdropStarted() external view returns (bool);

  /**
   * @notice Allow DAO fund to claim the airdrop
   */
  function allowDaoFund() external;

  /**
   * @notice Check if DAO fund is allowed to claim the airdrop
   */
  function daoFundAllowed() external view returns (bool);

  /**
   * @notice Claim the airdrop
   */
  function addUserAmount(address user, uint256 amount) external;

  /**
   * @notice Subtract the user's amount
   */
  function subUserAmount(address user, uint256 amount) external;

  /**
   * @notice Claim the airdrop
   */
  function claim() external;
}

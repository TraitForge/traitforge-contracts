// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface INukeFund {
    // Events for logging contract activities
    event FundBalanceUpdated(uint256 newBalance);
    event FundReceived(address indexed from, uint256 amount);
    event Nuked(address indexed owner, uint256 indexed tokenId, uint256 nukeAmount);
    event DevShareDistributed(uint256 devShare);
    event TraitForgeNftAddressUpdated(address indexed newAddress);
    event AirdropAddressUpdated(address indexed newAddress);
    event DevAddressUpdated(address indexed newAddress);
    event DaoAddressUpdated(address indexed newAddress);
    event EmpActivated(uint256 tokenId, uint256 unpauseAt);

    // Fallback function to receive ETH and update fund balance
    receive() external payable;

    function setTaxCut(uint256 _taxCut) external;

    function setMinimumDaysHeld(uint256 value) external;

    function setDefaultNukeFactorIncrease(uint256 value) external;

    function setMaxAllowedClaimDivisor(uint256 value) external;

    function setNukeFactorMaxParam(uint256 value) external;

    // View function to see the current balance of the fund
    function getFundBalance() external view returns (uint256);

    // Calculate the age of a token based on its creation timestamp and current time
    function calculateAge(uint256 tokenId) external view returns (uint256);

    // Calculate the nuke factor of a token, which affects the claimable amount from the fund
    function calculateNukeFactor(uint256 tokenId) external view returns (uint256);

    function nuke(uint256 tokenId) external;

    function canTokenBeNuked(uint256 tokenId) external view returns (bool);
}

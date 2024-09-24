// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { IAirdrop } from "contracts/interfaces/IAirdrop.sol";
import { IAddressProvider } from "contracts/interfaces/IAddressProvider.sol";
import { Roles } from "contracts/libraries/Roles.sol";
import { Errors } from "contracts/libraries/Errors.sol";
import { AddressProviderResolver } from "contracts/core/AddressProviderResolver.sol";

contract Airdrop is IAirdrop, AddressProviderResolver, ReentrancyGuard, Pausable {
    // Type declarations

    // Events

    // Modifiers

    // State variables
    bool private started;
    bool private daoAllowed;

    uint256 public totalTokenAmount;
    uint256 public totalValue;

    mapping(address => uint256) public userInfo;

    // Errors
    error Airdrop__AlreadyStarted();
    error Airdrop__InvalidAmount();
    error Airdrop__NotStarted();
    error Airdrop__AlreadyAllowed();
    error Airdrop__NotEligible();
    error Airdrop__AddressZero();

    // Functions

    constructor(address addressProvider) AddressProviderResolver(addressProvider) { }

    /**
     * external & public functions *******************************
     */

    //////////////////////////// write functions ////////////////////////////

    // only accessible from NFT contract
    function startAirdrop(uint256 amount) external whenNotPaused nonReentrant onlyAirdropAccessor {
        if (started) revert Airdrop__AlreadyStarted();
        if (amount == 0) revert Airdrop__InvalidAmount();
        if (address(_getTraitToken()) == address(0)) revert Airdrop__AddressZero();
        started = true;
        totalTokenAmount = amount;
        _getTraitToken().transferFrom(msg.sender, address(this), amount);
    }

    function allowDaoFund() external onlyAirdropAccessor {
        if (!started) revert Airdrop__NotStarted();
        if (daoAllowed) revert Airdrop__AlreadyAllowed();
        daoAllowed = true;
    }

    function addUserAmount(address user, uint256 amount) external whenNotPaused nonReentrant onlyAirdropAccessor {
        if (!started) revert Airdrop__NotStarted();
        userInfo[user] += amount;
        totalValue += amount;
    }

    function subUserAmount(address user, uint256 amount) external whenNotPaused nonReentrant onlyAirdropAccessor {
        if (!started) revert Airdrop__NotStarted();
        if (userInfo[user] < amount) revert Airdrop__InvalidAmount();
        userInfo[user] -= amount;
        totalValue -= amount;
    }

    function claim() external whenNotPaused nonReentrant {
        if (!started) revert Airdrop__NotStarted();
        if (userInfo[msg.sender] <= 0) revert Airdrop__NotEligible();

        uint256 amount = (totalTokenAmount * userInfo[msg.sender]) / totalValue;
        _getTraitToken().transfer(msg.sender, amount);
        userInfo[msg.sender] = 0;
    }

    function pause() public onlyProtocolMaintainer {
        _pause();
    }

    function unpause() public onlyProtocolMaintainer {
        _unpause();
    }

    //////////////////////////// read functions ////////////////////////////
    function airdropStarted() external view returns (bool) {
        return started;
    }

    function daoFundAllowed() external view returns (bool) {
        return daoAllowed;
    }

    /**
     * internal & private *******************************************
     */
    function _getTraitToken() private view returns (IERC20) {
        return IERC20(_addressProvider.getTrait());
    }
}

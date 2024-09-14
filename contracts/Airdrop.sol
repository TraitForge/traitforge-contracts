// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";
import {IAirdrop} from "contracts/interfaces/IAirdrop.sol";

contract Airdrop is IAirdrop, Ownable, ReentrancyGuard, Pausable {
    //   Type declarations

    // Events

    // Modifiers

    // State variables
    bool private started;
    bool private daoAllowed;

    IERC20 public traitToken;
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

    // constructor(address _traitToken) {
    //     _setTraitToken(_traitToken);
    // }

    /**
     * external & public functions *******************************
     */

    //////////////////////////// write functions ////////////////////////////
    function setTraitToken(address _traitToken) external onlyOwner {
        _setTraitToken(_traitToken);
    }

    function startAirdrop(uint256 amount) external whenNotPaused nonReentrant onlyOwner {
        if (started) revert Airdrop__AlreadyStarted();
        if (amount == 0) revert Airdrop__InvalidAmount();
        if (address(traitToken) == address(0)) revert Airdrop__AddressZero();
        started = true;
        totalTokenAmount = amount;
        traitToken.transferFrom(msg.sender, address(this), amount);
    }

    function allowDaoFund() external onlyOwner {
        if (!started) revert Airdrop__NotStarted();
        if (daoAllowed) revert Airdrop__AlreadyAllowed();
        daoAllowed = true;
    }

    function addUserAmount(address user, uint256 amount) external whenNotPaused nonReentrant onlyOwner {
        if (!started) revert Airdrop__NotStarted();
        userInfo[user] += amount;
        totalValue += amount;
    }

    function subUserAmount(address user, uint256 amount) external whenNotPaused nonReentrant onlyOwner {
        if (!started) revert Airdrop__NotStarted();
        if (userInfo[user] < amount) revert Airdrop__InvalidAmount();
        userInfo[user] -= amount;
        totalValue -= amount;
    }

    function claim() external whenNotPaused nonReentrant {
        if (!started) revert Airdrop__NotStarted();
        if (userInfo[msg.sender] <= 0) revert Airdrop__NotEligible();

        uint256 amount = (totalTokenAmount * userInfo[msg.sender]) / totalValue;
        traitToken.transfer(msg.sender, amount);
        userInfo[msg.sender] = 0;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
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
    function _setTraitToken(address _traitToken) private {
        if (_traitToken == address(0)) revert Airdrop__AddressZero();
        traitToken = IERC20(_traitToken);
    }
}

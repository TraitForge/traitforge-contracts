// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { IDevFund } from "./interfaces/IDevFund.sol";
import { AddressProviderResolver } from "contracts/core/AddressProviderResolver.sol";

contract DevFund is IDevFund, AddressProviderResolver, ReentrancyGuard, Pausable {
    // State variables
    uint256 public totalDevWeight;
    uint256 public totalRewardDebt;
    mapping(address => DevInfo) public devInfo;
    address public ethCollector;

    // Errors
    error DevFund__InvalidWeight();
    error DevFund__AlreadyRegistered();
    error DevFund__NotRegistered();
    error DevFund__AddressZero();

    constructor(address addressProvider, address _ethCollector) AddressProviderResolver(addressProvider) {
        if (_ethCollector == address(0)) revert DevFund__AddressZero();
        ethCollector = _ethCollector;
    }

    receive() external payable {
        if (totalDevWeight > 0) {
            uint256 amountPerWeight = msg.value / totalDevWeight;
            uint256 remaining = msg.value - (amountPerWeight * totalDevWeight);
            totalRewardDebt += amountPerWeight;
            if (remaining > 0) {
                (bool success,) = payable(ethCollector).call{ value: remaining }("");
                require(success, "Failed to send Ether to owner");
            }
        } else {
            (bool success,) = payable(ethCollector).call{ value: msg.value }("");
            require(success, "Failed to send Ether to owner");
        }
        emit FundReceived(msg.sender, msg.value);
    }

    function pause() public onlyProtocolMaintainer {
        _pause();
    }

    function unpause() public onlyProtocolMaintainer {
        _unpause();
    }

    function addDev(address user, uint256 weight) external onlyDevFundAccessor {
        DevInfo storage info = devInfo[user];
        if (weight == 0) revert DevFund__InvalidWeight();
        if (info.weight != 0) revert DevFund__AlreadyRegistered();
        info.rewardDebt = totalRewardDebt;
        info.weight = weight;
        totalDevWeight += weight;
        emit AddDev(user, weight);
    }

    function updateDev(address user, uint256 weight) external onlyDevFundAccessor {
        DevInfo storage info = devInfo[user];
        if (weight == 0) revert DevFund__InvalidWeight();
        if (info.weight == 0) revert DevFund__NotRegistered();
        totalDevWeight = totalDevWeight - info.weight + weight;
        info.pendingRewards += (totalRewardDebt - info.rewardDebt) * info.weight;
        info.rewardDebt = totalRewardDebt;
        info.weight = weight;
        emit UpdateDev(user, weight);
    }

    function removeDev(address user) external onlyDevFundAccessor {
        DevInfo storage info = devInfo[user];
        if (info.weight == 0) revert DevFund__NotRegistered();
        totalDevWeight -= info.weight;
        info.pendingRewards += (totalRewardDebt - info.rewardDebt) * info.weight;
        info.rewardDebt = totalRewardDebt;
        info.weight = 0;
        emit RemoveDev(user);
    }

    function claim() external whenNotPaused nonReentrant {
        DevInfo storage info = devInfo[msg.sender];

        uint256 pending = info.pendingRewards + (totalRewardDebt - info.rewardDebt) * info.weight;

        if (pending > 0) {
            uint256 claimedAmount = safeRewardTransfer(msg.sender, pending);
            info.pendingRewards = pending - claimedAmount;
            emit Claim(msg.sender, claimedAmount);
        }

        info.rewardDebt = totalRewardDebt;
    }

    function pendingRewards(address user) external view returns (uint256) {
        DevInfo storage info = devInfo[user];
        return info.pendingRewards + (totalRewardDebt - info.rewardDebt) * info.weight;
    }

    function safeRewardTransfer(address to, uint256 amount) internal returns (uint256) {
        uint256 _rewardBalance = payable(address(this)).balance;
        if (amount > _rewardBalance) amount = _rewardBalance;
        (bool success,) = payable(to).call{ value: amount }("");
        require(success, "Failed to send Reward");
        return amount;
    }
}

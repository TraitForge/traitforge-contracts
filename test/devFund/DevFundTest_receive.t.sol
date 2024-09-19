// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";
import { DevFundTest } from "./DevFundTest.t.sol";

contract DevFundTest_receive is DevFundTest {
    uint256 amount = 10 ether;
    uint256 weight = 5;

    function test_devFund__receive__withTotalDevWeightIsZero() public {
        uint256 ethCollectorBalanceBefore = _devFund.ethCollector().balance;
        vm.deal(_randomUser, amount);
        vm.expectEmit(address(_devFund));
        emit FundReceived(_randomUser, amount);
        vm.prank(_randomUser);
        (bool success,) = payable(address(_devFund)).call{ value: amount }("");
        assert(success);
        assert(_devFund.ethCollector().balance == ethCollectorBalanceBefore + amount);
    }

    function test_devFund__receive__withTotalDevWeightIsHigherThanZero() public {
        // add dev to have a total dev weight higher than zero
        vm.prank(_devFundAccessor);
        _devFund.addDev(_randomUser, weight);

        uint256 ethCollectorBalanceBefore = _devFund.ethCollector().balance;
        uint256 devFundBalanceBefore = address(_devFund).balance;
        vm.deal(_randomUser, amount);
        vm.expectEmit(address(_devFund));
        emit FundReceived(_randomUser, amount);
        vm.prank(_randomUser);
        (bool success,) = payable(address(_devFund)).call{ value: amount }("");

        uint256 amountDevFundShouldReceive = amount / weight * _devFund.totalDevWeight();
        uint256 amountOwnerShouldReceive = amount - amountDevFundShouldReceive;
        assert(success);
        assert(address(_devFund).balance == devFundBalanceBefore + amountDevFundShouldReceive);
        assert(_devFund.ethCollector().balance == ethCollectorBalanceBefore + amountOwnerShouldReceive);
        assert(_devFund.totalRewardDebt() == amount / _devFund.totalDevWeight());
    }
}

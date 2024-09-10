// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DevFundTest} from "./DevFundTest.t.sol";

contract DevFundTest_receive is DevFundTest {
    address user = makeAddr("user");
    uint256 amount = 10 ether;
    uint256 weight = 5;

    function test_devFund__receive__withTotalDevWeightIsZero() public {
        uint256 ownerBalanceBefore = owner.balance;
        vm.deal(user, amount);
        vm.expectEmit(address(devFund));
        emit FundReceived(user, amount);
        vm.prank(user);
        (bool success, ) = payable(address(devFund)).call{ value: amount }('');
        assert(success);
        assert(owner.balance == ownerBalanceBefore + amount);
    }

    function test_devFund__receive__withTotalDevWeightIsHigherThanZero() public {
        // add dev to have a total dev weight higher than zero
        vm.prank(owner);
        devFund.addDev(user, weight);

        uint256 ownerBalanceBefore = owner.balance;
        uint256 devFundBalanceBefore = address(devFund).balance;
        vm.deal(user, amount);
        vm.expectEmit(address(devFund));
        emit FundReceived(user, amount);
        vm.prank(user);
        (bool success, ) = payable(address(devFund)).call{ value: amount }('');

        uint256 amountDevFundShouldReceive = amount / weight * devFund.totalDevWeight();
        uint256 amountOwnerShouldReceive = amount - amountDevFundShouldReceive;
        assert(success);
        assert(address(devFund).balance == devFundBalanceBefore + amountDevFundShouldReceive);
        assert(owner.balance == ownerBalanceBefore + amountOwnerShouldReceive);
        assert(devFund.totalRewardDebt() == amount / devFund.totalDevWeight());
    }



}
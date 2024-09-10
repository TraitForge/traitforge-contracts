// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DevFundTest} from "./DevFundTest.t.sol";
import {DevFund} from "contracts/DevFund/DevFund.sol";


contract DevFundTest_addDev is DevFundTest {
    address user = makeAddr("user");
    uint256 amount = 10 ether;
    uint256 weight = 5;

    function testRevert_devFund__addDev__whenIsNotAuthorized() public {
        vm.prank(user);
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        devFund.addDev(user, weight);
    }

    function testRevert_devFund__addDev__whenWeightIsZero() public {
        vm.prank(owner);
        vm.expectRevert(DevFund.DevFund__InvalidWeight.selector);
        devFund.addDev(user, 0);
    }

    function testRevert_devFund__addDev__whenDevAlreadyRegistered() public {
        // add dev first
        vm.startPrank(owner);
        devFund.addDev(user, weight);

        vm.expectRevert(DevFund.DevFund__AlreadyRegistered.selector);
        devFund.addDev(user, weight);
    }

    function test_devFund__addDev() public {
        uint256 tdwBefore = devFund.totalDevWeight();
        vm.expectEmit(address(devFund));
        emit AddDev(user, weight);
        vm.startPrank(owner);
        devFund.addDev(user, weight);
        (uint256 devWeight, uint256 devRewardDebt, ) = devFund.devInfo(user);
        assertEq(devFund.totalRewardDebt(), devRewardDebt);
        assertEq(devWeight, weight);
        assertEq(devFund.totalDevWeight(), tdwBefore + weight);
    }



}
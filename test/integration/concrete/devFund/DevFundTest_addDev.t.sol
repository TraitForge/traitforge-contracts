// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "@forge-std/Test.sol";
import { DevFundTest } from "./DevFundTest.t.sol";
import { DevFund } from "contracts/DevFund.sol";
import { Errors } from "contracts/libraries/Errors.sol";

contract DevFundTest_addDev is DevFundTest {
    uint256 amount = 10 ether;
    uint256 weight = 5;

    function testRevert_devFund__addDev__whenIsNotAuthorized() public {
        vm.prank(_randomUser);
        vm.expectRevert(abi.encodeWithSelector(Errors.CallerNotDevFundAccessor.selector, _randomUser));
        _devFund.addDev(_dev, weight);
    }

    function testRevert_devFund__addDev__whenWeightIsZero() public {
        vm.prank(_devFundAccessor);
        vm.expectRevert(DevFund.DevFund__InvalidWeight.selector);
        _devFund.addDev(_dev, 0);
    }

    function testRevert_devFund__addDev__whenDevAlreadyRegistered() public {
        // add dev first
        vm.startPrank(_devFundAccessor);
        _devFund.addDev(_dev, weight);

        vm.expectRevert(DevFund.DevFund__AlreadyRegistered.selector);
        _devFund.addDev(_dev, weight);
    }

    function test_devFund__addDev() public {
        uint256 tdwBefore = _devFund.totalDevWeight();
        vm.expectEmit(address(_devFund));
        emit AddDev(_dev, weight);
        vm.startPrank(_devFundAccessor);
        _devFund.addDev(_dev, weight);
        (uint256 devWeight, uint256 devRewardDebt,) = _devFund.devInfo(_dev);
        assertEq(_devFund.totalRewardDebt(), devRewardDebt);
        assertEq(devWeight, weight);
        assertEq(_devFund.totalDevWeight(), tdwBefore + weight);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "@forge-std/Test.sol";
import { DevFundTest } from "./DevFundTest.t.sol";
import { DevFund } from "contracts/DevFund.sol";
import { Errors } from "contracts/libraries/Errors.sol";

contract DevFundTest_updateDev is DevFundTest {
    uint256 amount = 10 ether;
    uint256 weight = 5;

    function testRevert_devFund__updateDev__whenIsNotAuthorized() public {
        vm.prank(_randomUser);
        vm.expectRevert(abi.encodeWithSelector(Errors.CallerNotDevFundAccessor.selector, _randomUser));
        _devFund.updateDev(_dev, weight);
    }

    function testRevert_devFund__updateDev__whenWeightIsZero() public {
        vm.prank(_devFundAccessor);
        vm.expectRevert(DevFund.DevFund__InvalidWeight.selector);
        _devFund.updateDev(_dev, 0);
    }

    function testRevert_devFund__updateDev__whenDevIsNotRegistered() public {
        vm.prank(_devFundAccessor);
        vm.expectRevert(DevFund.DevFund__NotRegistered.selector);
        _devFund.updateDev(_dev, weight);
    }

    function test_devFund__updateDev() public {
        vm.startPrank(_devFundAccessor);
        _devFund.addDev(_dev, weight);

        uint256 tdwBefore = _devFund.totalDevWeight();
        (uint256 devWeightBf, uint256 devRewardDebtBf, uint256 pendingRewardsBf) = _devFund.devInfo(_dev);
        vm.expectEmit(address(_devFund));
        emit UpdateDev(_dev, weight);
        _devFund.updateDev(_dev, weight);

        (uint256 devWeight, uint256 devRewardDebt, uint256 pendingRewards) = _devFund.devInfo(_dev);
        assertEq(_devFund.totalRewardDebt(), devRewardDebt);
        assertEq(pendingRewards, pendingRewardsBf + ((_devFund.totalRewardDebt() - devRewardDebtBf) * devWeightBf));
        assertEq(_devFund.totalDevWeight(), tdwBefore - devWeightBf + weight);
        assertEq(devRewardDebt, _devFund.totalRewardDebt());
        assertEq(devWeight, weight);
    }
}

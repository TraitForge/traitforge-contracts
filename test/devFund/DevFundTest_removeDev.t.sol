// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";
import { DevFundTest } from "./DevFundTest.t.sol";
import { DevFund } from "contracts/DevFund.sol";
import { Errors } from "contracts/libraries/Errors.sol";

contract DevFundTest_removeDev is DevFundTest {
    uint256 amount = 10 ether;
    uint256 weight = 5;

    function testRevert_devFund__removeDev__whenIsNotAuthorized() public {
        vm.prank(_randomUser);
        vm.expectRevert(abi.encodeWithSelector(Errors.CallerNotDevFundAccessor.selector, _randomUser));
        _devFund.removeDev(_dev);
    }

    function testRevert_devFund__removeDev__whenDevIsNotRegistered() public {
        vm.prank(_devFundAccessor);
        vm.expectRevert(DevFund.DevFund__NotRegistered.selector);
        _devFund.removeDev(_dev);
    }

    function test_devFund__removeDev() public {
        vm.startPrank(_devFundAccessor);
        _devFund.addDev(_dev, weight);

        uint256 tdwBefore = _devFund.totalDevWeight();
        (uint256 devWeightBf, uint256 devRewardDebtBf, uint256 pendingRewardsBf) = _devFund.devInfo(_dev);
        vm.expectEmit(address(_devFund));
        emit RemoveDev(_dev);
        _devFund.removeDev(_dev);

        (uint256 devWeight, uint256 devRewardDebt, uint256 pendingRewards) = _devFund.devInfo(_dev);
        assertEq(_devFund.totalDevWeight(), tdwBefore - devWeightBf);
        assertEq(pendingRewards, pendingRewardsBf + ((_devFund.totalRewardDebt() - devRewardDebtBf) * devWeightBf));
        assertEq(devRewardDebt, _devFund.totalRewardDebt());
        assertEq(devWeight, 0);
    }
}

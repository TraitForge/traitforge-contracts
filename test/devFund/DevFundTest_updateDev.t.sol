// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DevFundTest} from "./DevFundTest.t.sol";
import {DevFund} from "contracts/DevFund.sol";

contract DevFundTest_updateDev is DevFundTest {
    address user = makeAddr("user");
    uint256 amount = 10 ether;
    uint256 weight = 5;

    function testRevert_devFund__updateDev__whenIsNotAuthorized() public {
        vm.prank(user);
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        devFund.updateDev(user, weight);
    }

    function testRevert_devFund__updateDev__whenWeightIsZero() public {
        vm.prank(owner);
        vm.expectRevert(DevFund.DevFund__InvalidWeight.selector);
        devFund.updateDev(user, 0);
    }

    function testRevert_devFund__updateDev__whenDevIsNotRegistered() public {
        vm.prank(owner);
        vm.expectRevert(DevFund.DevFund__NotRegistered.selector);
        devFund.updateDev(user, weight);
    }

    function test_devFund__updateDev() public {
        vm.startPrank(owner);
        devFund.addDev(user, weight);

        uint256 tdwBefore = devFund.totalDevWeight();
        (uint256 devWeightBf, uint256 devRewardDebtBf, uint256 pendingRewardsBf) = devFund.devInfo(user);
        vm.expectEmit(address(devFund));
        emit UpdateDev(user, weight);
        devFund.updateDev(user, weight);

        (uint256 devWeight, uint256 devRewardDebt, uint256 pendingRewards) = devFund.devInfo(user);
        assertEq(devFund.totalRewardDebt(), devRewardDebt);
        assertEq(pendingRewards, pendingRewardsBf + ((devFund.totalRewardDebt() - devRewardDebtBf) * devWeightBf));
        assertEq(devFund.totalDevWeight(), tdwBefore - devWeightBf + weight);
        assertEq(devRewardDebt, devFund.totalRewardDebt());
        assertEq(devWeight, weight);
    }
}

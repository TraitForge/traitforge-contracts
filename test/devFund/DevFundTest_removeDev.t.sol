// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DevFundTest} from "./DevFundTest.t.sol";
import {DevFund} from "contracts/DevFund.sol";

contract DevFundTest_removeDev is DevFundTest {
    address user = makeAddr("user");
    uint256 amount = 10 ether;
    uint256 weight = 5;

    function testRevert_devFund__removeDev__whenIsNotAuthorized() public {
        vm.prank(user);
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        devFund.removeDev(user);
    }

    function testRevert_devFund__removeDev__whenDevIsNotRegistered() public {
        vm.prank(owner);
        vm.expectRevert(DevFund.DevFund__NotRegistered.selector);
        devFund.removeDev(user);
    }

    function test_devFund__removeDev() public {
        vm.startPrank(owner);
        devFund.addDev(user, weight);

        uint256 tdwBefore = devFund.totalDevWeight();
        (uint256 devWeightBf, uint256 devRewardDebtBf, uint256 pendingRewardsBf) = devFund.devInfo(user);
        vm.expectEmit(address(devFund));
        emit RemoveDev(user);
        devFund.removeDev(user);

        (uint256 devWeight, uint256 devRewardDebt, uint256 pendingRewards) = devFund.devInfo(user);
        assertEq(devFund.totalDevWeight(), tdwBefore - devWeightBf);
        assertEq(pendingRewards, pendingRewardsBf + ((devFund.totalRewardDebt() - devRewardDebtBf) * devWeightBf));
        assertEq(devRewardDebt, devFund.totalRewardDebt());
        assertEq(devWeight, 0);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DevFundTest} from "./DevFundTest.t.sol";
import {DevFund} from "contracts/DevFund.sol";

contract DevFundTest_claim is DevFundTest {
    address dev1 = makeAddr("dev1");
    address dev2 = makeAddr("dev2");
    address dev3 = makeAddr("dev3");
    uint256 amountToDevFund = 30 ether;
    uint256 weightDev1 = 5;
    uint256 weightDev2 = 10;
    uint256 weightDev3 = 15;

    function test_devFund__claim__whenDevNotAdded() public {
        vm.prank(dev1);
        devFund.claim();
        (, uint256 devRewardDebt,) = devFund.devInfo(dev1);
        assertEq(devFund.totalRewardDebt(), devRewardDebt);
    }

    function test_devFund__claim() public {
        _addDevsAndETH();
        (uint256 devWeightBF, uint256 devRewardDebtBF,) = devFund.devInfo(dev1);
        vm.prank(dev1);
        devFund.claim();
        (, uint256 devRewardDebt, uint256 devPendingRewards) = devFund.devInfo(dev1);
        assertEq(devFund.totalRewardDebt(), devRewardDebt);
        assertEq(devPendingRewards, 0);
        assertEq((devFund.totalRewardDebt() - devRewardDebtBF) * devWeightBF, dev1.balance);
    }

    function _addDevsAndETH() internal {
        vm.startPrank(owner);
        vm.deal(owner, amountToDevFund);
        devFund.addDev(dev1, weightDev1);
        devFund.addDev(dev2, weightDev2);
        devFund.addDev(dev3, weightDev3);
        (bool success,) = payable(address(devFund)).call{value: amountToDevFund}("");
        assert(success);
        vm.stopPrank();
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "@forge-std/Test.sol";
import { DevFundTest } from "./DevFundTest.t.sol";
import { DevFund } from "contracts/DevFund.sol";

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
        _devFund.claim();
        (, uint256 devRewardDebt,) = _devFund.devInfo(dev1);
        assertEq(_devFund.totalRewardDebt(), devRewardDebt);
    }

    function test_devFund__claim() public {
        _addDevsAndETH();
        (uint256 devWeightBF, uint256 devRewardDebtBF,) = _devFund.devInfo(dev1);
        vm.prank(dev1);
        _devFund.claim();
        (, uint256 devRewardDebt, uint256 devPendingRewards) = _devFund.devInfo(dev1);
        assertEq(_devFund.totalRewardDebt(), devRewardDebt);
        assertEq(devPendingRewards, 0);
        assertEq((_devFund.totalRewardDebt() - devRewardDebtBF) * devWeightBF, dev1.balance);
    }

    function _addDevsAndETH() internal {
        vm.startPrank(_devFundAccessor);
        vm.deal(_devFundAccessor, amountToDevFund);
        _devFund.addDev(dev1, weightDev1);
        _devFund.addDev(dev2, weightDev2);
        _devFund.addDev(dev3, weightDev3);
        (bool success,) = payable(address(_devFund)).call{ value: amountToDevFund }("");
        assert(success);
        vm.stopPrank();
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DevFundTest} from "./DevFundTest.t.sol";

contract DevFundTest_unpause is DevFundTest {
    address user = makeAddr("user");

    function testRevert_devFund__unpause__whenUserNotAuthorized() public {
        // we need to pause the contract first
        vm.prank(owner);
        devFund.pause();

        vm.prank(user);
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        devFund.unpause();
    }

    function testRevert_devFund__unpause__whenIsNotPaused() public {
        vm.prank(owner);
        vm.expectRevert(bytes("Pausable: not paused"));
        devFund.unpause();
    }

    function test_devFund__unpause() public {
        // we need to pause the contract first
        vm.startPrank(owner);
        devFund.pause();

        devFund.unpause();
        assertEq(devFund.paused(), false);
    }
}

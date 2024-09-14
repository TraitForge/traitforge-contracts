// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DevFundTest} from "./DevFundTest.t.sol";

contract DevFundTest_pause is DevFundTest {
    address user = makeAddr("user");

    function testRevert_devFund__pause__whenUserNotAuthorized() public {
        vm.prank(user);
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        devFund.pause();
    }

    function test_devFund__pause() public {
        vm.prank(owner);
        devFund.pause();
        assertEq(devFund.paused(), true);
    }
}

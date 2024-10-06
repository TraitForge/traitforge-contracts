// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "@forge-std/Test.sol";
import { DevFundTest } from "./DevFundTest.t.sol";
import { Errors } from "contracts/libraries/Errors.sol";

contract DevFundTest_pause is DevFundTest {
    address user = makeAddr("user");

    function testRevert_devFund__pause__whenUserNotAuthorized() public {
        vm.prank(_randomUser);
        vm.expectRevert(abi.encodeWithSelector(Errors.CallerNotProtocolMaintainer.selector, _randomUser));
        _devFund.pause();
    }

    function test_devFund__pause() public {
        vm.prank(_protocolMaintainer);
        _devFund.pause();
        assertEq(_devFund.paused(), true);
    }
}

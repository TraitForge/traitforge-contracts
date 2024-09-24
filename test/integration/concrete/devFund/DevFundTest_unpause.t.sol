// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "@forge-std/Test.sol";
import { DevFundTest } from "./DevFundTest.t.sol";
import { Errors } from "contracts/libraries/Errors.sol";

contract DevFundTest_unpause is DevFundTest {
    address user = makeAddr("user");

    function testRevert_devFund__unpause__whenUserNotAuthorized() public {
        // we need to pause the contract first
        vm.prank(_protocolMaintainer);
        _devFund.pause();

        vm.prank(_randomUser);
        vm.expectRevert(abi.encodeWithSelector(Errors.CallerNotProtocolMaintainer.selector, _randomUser));
        _devFund.unpause();
    }

    function testRevert_devFund__unpause__whenIsNotPaused() public {
        vm.prank(_protocolMaintainer);
        vm.expectRevert(bytes("Pausable: not paused"));
        _devFund.unpause();
    }

    function test_devFund__unpause() public {
        // we need to pause the contract first
        vm.startPrank(_protocolMaintainer);
        _devFund.pause();
        _devFund.unpause();
        assertEq(_devFund.paused(), false);
    }
}

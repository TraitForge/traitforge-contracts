// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { AirdropTest } from "test/airdrop/AirdropTest.t.sol";
import { Airdrop } from "contracts/Airdrop.sol";
import { Errors } from "contracts/libraries/Errors.sol";

contract Airdrop_StartAirdrop is AirdropTest {
    function testRevert__airdrop__whenNotAuthorized() public {
        vm.expectRevert(abi.encodeWithSelector(Errors.CallerNotAirdropAccessor.selector, _randomUser));
        vm.prank(_randomUser);
        _airdrop.startAirdrop(amount);
    }

    function testRevert__airdrop__whenIsPaused() public {
        vm.prank(_protocolMaintainer);
        _airdrop.pause();
        vm.expectRevert(bytes("Pausable: paused"));
        _airdrop.startAirdrop(amount);
    }

    function testRevert__airdrop__whenHasAlreadyStarted() public {
        _startAirdrop();
        vm.startPrank(_airdropAccessor);
        vm.expectRevert(Airdrop.Airdrop__AlreadyStarted.selector);
        _airdrop.startAirdrop(amount);
    }

    function testRevert__airdrop__whenAmountIsZero() public {
        vm.startPrank(_airdropAccessor);
        vm.expectRevert(Airdrop.Airdrop__InvalidAmount.selector);
        _airdrop.startAirdrop(0);
    }

    function test__airdrop__startAirdrop() public {
        _startAirdrop();

        assertEq(_airdrop.totalTokenAmount(), amount);
        assertEq(_trait.balanceOf(address(_airdrop)), amount);
        assertEq(_airdrop.airdropStarted(), true);
    }
}

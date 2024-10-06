// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { AirdropTest } from "../airdrop/AirdropTest.t.sol";
import { Airdrop } from "contracts/Airdrop.sol";
import { Errors } from "contracts/libraries/Errors.sol";

contract Airdrop_SubUserAmount is AirdropTest {
    address user = makeAddr("user");
    uint256 amountToAdd = 10 ether;
    uint256 amountToSub = 1 ether;

    function testRevert_when_not_owner() public {
        _startAirdrop();
        vm.expectRevert(abi.encodeWithSelector(Errors.CallerNotAirdropAccessor.selector, _randomUser));
        vm.prank(_randomUser);
        _airdrop.subUserAmount(user, amountToSub);
    }

    function testRevert_whenStarted() public {
        _startAirdrop();
        vm.prank(_airdropAccessor);
        vm.expectRevert(Airdrop.Airdrop__AlreadyStarted.selector);
        _airdrop.subUserAmount(user, amountToSub);
    }

    function testRevert_when_is_paused() public {
        vm.prank(_protocolMaintainer);
        _airdrop.pause();
        vm.expectRevert(bytes("Pausable: paused"));
        _airdrop.subUserAmount(user, amountToSub);
    }

    function testRevert_when_amountToSub_higher_than_user_balance() public {
        vm.prank(_airdropAccessor);
        vm.expectRevert(Airdrop.Airdrop__InvalidAmount.selector);
        _airdrop.subUserAmount(user, amountToSub);
    }

    function test_SubUserAmount() public {
        vm.startPrank(_airdropAccessor);
        _airdrop.addUserAmount(user, amountToAdd);
        uint256 totalValueBefore = _airdrop.totalValue();
        _airdrop.subUserAmount(user, amountToSub);
        assertEq(_airdrop.userInfo(user), amountToAdd - amountToSub);
        assertEq(_airdrop.totalValue(), totalValueBefore - amountToSub);
    }
}

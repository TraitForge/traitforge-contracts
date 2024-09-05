// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AirdropTest} from "test/airdrop/AirdropTest.t.sol";
import {Airdrop} from "contracts/Airdrop/Airdrop.sol";

contract Airdrop_SubUserAmount is AirdropTest {
    address user = makeAddr("user");
    uint256 amountToAdd = 10 ether;
    uint256 amountToSub = 1 ether;

    function testRevert_when_not_owner() public {
        _startAirdrop();
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        airdrop.subUserAmount(user, amountToSub);
    }

    function testRevert_when_not_started() public {
        vm.prank(owner);
        vm.expectRevert(Airdrop.Airdrop__NotStarted.selector);
        airdrop.subUserAmount(user, amountToSub);
    }

    function testRevert_when_is_paused() public {
        _startAirdrop();
        vm.prank(owner);
        airdrop.pause();
        vm.expectRevert(bytes("Pausable: paused"));
        airdrop.subUserAmount(user, amountToSub);
    }

    function testRevert_when_amountToSub_higher_than_user_balance() public {
        _startAirdrop();
        vm.prank(owner);
        vm.expectRevert(Airdrop.Airdrop__InvalidAmount.selector);
        airdrop.subUserAmount(user, amountToSub);
    }

    function test_SubUserAmount() public {
        _startAirdrop();
        vm.startPrank(owner);
        airdrop.addUserAmount(user, amountToAdd);
        uint256 totalValueBefore = airdrop.totalValue();
        airdrop.subUserAmount(user, amountToSub);
        assertEq(airdrop.userInfo(user), amountToAdd - amountToSub);
        assertEq(airdrop.totalValue(), totalValueBefore - amountToSub);
    }
}

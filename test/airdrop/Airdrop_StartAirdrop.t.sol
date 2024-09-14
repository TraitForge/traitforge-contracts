// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AirdropTest} from "test/airdrop/AirdropTest.t.sol";
import {Airdrop} from "contracts/Airdrop.sol";

contract Airdrop_StartAirdrop is AirdropTest {
    function testRevert_when_not_owner() public {
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        airdrop.startAirdrop(amount);
    }

    function testRevert_when_paused() public {
        vm.prank(owner);
        airdrop.pause();
        vm.expectRevert(bytes("Pausable: paused"));
        airdrop.startAirdrop(amount);
    }

    function testRevert_when_already_started() public {
        _transferAndApproveTrait();
        airdrop.setTraitToken(address(trait));
        airdrop.startAirdrop(amount);
        vm.expectRevert(Airdrop.Airdrop__AlreadyStarted.selector);
        airdrop.startAirdrop(amount);
    }

    function testRevert_when_amount_is_zero() public {
        vm.startPrank(owner);
        airdrop.setTraitToken(address(trait));
        vm.expectRevert(Airdrop.Airdrop__InvalidAmount.selector);
        airdrop.startAirdrop(0);
    }

    function testRevert_when_traitToken_is_zero() public {
        vm.startPrank(owner);
        vm.expectRevert(Airdrop.Airdrop__AddressZero.selector);
        airdrop.startAirdrop(amount);
    }

    function test_start_airdrop() public {
        _transferAndApproveTrait();
        airdrop.setTraitToken(address(trait));
        airdrop.startAirdrop(amount);

        assertEq(airdrop.totalTokenAmount(), amount);
        assertEq(trait.balanceOf(address(airdrop)), amount);
        assertEq(address(airdrop.traitToken()), address(trait));
        assertEq(airdrop.airdropStarted(), true);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AirdropTest} from "test/airdrop/AirdropTest.t.sol";
import {Airdrop} from "contracts/Airdrop/Airdrop.sol";

contract Airdrop_Claim is AirdropTest {
    address user = makeAddr("user");
    uint256 amountToAdd = 10 ether;

    function testRevert_when_not_started() public {
        vm.expectRevert(Airdrop.Airdrop__NotStarted.selector);
        airdrop.claim();
    }

    function testRevert_when_is_paused() public {
        _startAirdrop();
        vm.prank(owner);
        airdrop.pause();
        vm.expectRevert(bytes("Pausable: paused"));
        airdrop.claim();
    }

    function testRevert_if_nothing_to_claim() public {
        _startAirdrop();
        vm.expectRevert(Airdrop.Airdrop__NotEligible.selector);
        airdrop.claim();
    }

    function test_Claim() public {
        _startAirdrop();
        vm.prank(owner);
        airdrop.addUserAmount(user, amountToAdd);

        uint256 totalValueBefore = airdrop.totalValue();
        vm.prank(user);
        airdrop.claim();
        assertEq(trait.balanceOf(user), airdrop.totalTokenAmount() * amountToAdd / totalValueBefore);
        assertEq(trait.balanceOf(address(airdrop)), totalValueBefore - amountToAdd);
        assertEq(airdrop.userInfo(user), 0);
    }
}

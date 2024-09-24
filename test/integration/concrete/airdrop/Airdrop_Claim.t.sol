// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { AirdropTest } from "../airdrop/AirdropTest.t.sol";
import { Airdrop } from "contracts/Airdrop.sol";

contract Airdrop_Claim is AirdropTest {
    address user = makeAddr("user");
    uint256 amountToAdd = 10 ether;

    function testRevert_when_not_started() public {
        vm.expectRevert(Airdrop.Airdrop__NotStarted.selector);
        _airdrop.claim();
    }

    function testRevert_when_is_paused() public {
        _startAirdrop();
        vm.prank(_protocolMaintainer);
        _airdrop.pause();
        vm.expectRevert(bytes("Pausable: paused"));
        _airdrop.claim();
    }

    function testRevert_if_nothing_to_claim() public {
        _startAirdrop();
        vm.expectRevert(Airdrop.Airdrop__NotEligible.selector);
        _airdrop.claim();
    }

    function test_Claim() public {
        _startAirdrop();
        vm.prank(_airdropAccessor);
        _airdrop.addUserAmount(user, amountToAdd);

        uint256 totalValueBefore = _airdrop.totalValue();
        vm.prank(user);
        _airdrop.claim();
        assertEq(_trait.balanceOf(user), _airdrop.totalTokenAmount() * amountToAdd / totalValueBefore);
        assertEq(_trait.balanceOf(address(_airdrop)), totalValueBefore - amountToAdd);
        assertEq(_airdrop.userInfo(user), 0);
    }
}

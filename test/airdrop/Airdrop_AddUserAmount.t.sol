// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AirdropTest} from "test/airdrop/AirdropTest.t.sol";
import {Airdrop} from "contracts/Airdrop/Airdrop.sol";

contract Airdrop_AddUserAmount is AirdropTest {
    address user = makeAddr("user");

    function testRevert_when_not_owner() public {
        _startAirdrop();
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        airdrop.addUserAmount(user, 100);
    }

    function testRevert_when_not_started() public {
        vm.prank(owner);
        vm.expectRevert(Airdrop.Airdrop__NotStarted.selector);
        airdrop.addUserAmount(user, 100);
    }

    function testRevert_when_is_paused() public {
        _startAirdrop();
        vm.prank(owner);
        airdrop.pause();
        vm.expectRevert(bytes("Pausable: paused"));
        airdrop.addUserAmount(user, 100);
    }

    function test_AddUserAmount() public {
        _startAirdrop();
        uint256 totalValueBefore = airdrop.totalValue();
        vm.prank(owner);
        airdrop.addUserAmount(user, 100);
        assertEq(airdrop.userInfo(user), 100);
        assertEq(airdrop.totalValue(), totalValueBefore + 100);
    }
}

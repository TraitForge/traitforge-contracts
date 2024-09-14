// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AirdropTest} from "test/airdrop/AirdropTest.t.sol";
import {Airdrop} from "contracts/Airdrop.sol";

contract Airdrop_AddUserAmount is AirdropTest {
    address user = makeAddr("user");

    function testRevert__airdrop__whenNotOwner() public {
        _startAirdrop();
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        airdrop.addUserAmount(user, 100);
    }

    function testRevert__airdrop__whenNotStarted() public {
        vm.prank(owner);
        vm.expectRevert(Airdrop.Airdrop__NotStarted.selector);
        airdrop.addUserAmount(user, 100);
    }

    function testRevert__airdrop__whenIsPaused() public {
        _startAirdrop();
        vm.prank(owner);
        airdrop.pause();
        vm.expectRevert(bytes("Pausable: paused"));
        airdrop.addUserAmount(user, 100);
    }

    function test__airdrop__addUserAmount() public {
        _startAirdrop();
        uint256 totalValueBefore = airdrop.totalValue();
        vm.prank(owner);
        airdrop.addUserAmount(user, 100);
        assertEq(airdrop.userInfo(user), 100);
        assertEq(airdrop.totalValue(), totalValueBefore + 100);
    }
}

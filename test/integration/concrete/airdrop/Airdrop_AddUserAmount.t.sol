// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AirdropTest} from "../airdrop/AirdropTest.t.sol";
import {Airdrop} from "contracts/Airdrop.sol";
import {Errors} from "contracts/libraries/Errors.sol";



contract Airdrop_AddUserAmount is AirdropTest {
    address user = makeAddr("user");

    function testRevert__airdrop__addUserAmount__whenNotAuthorized() public {
        vm.expectRevert(abi.encodeWithSelector(Errors.CallerNotAirdropAccessor.selector, _randomUser));
        vm.prank(_randomUser);
        _airdrop.addUserAmount(user, 100);
    }

    function testRevert__airdrop__addUserAmount__whenStarted() public {
        _startAirdrop();
        vm.prank(_airdropAccessor);
        vm.expectRevert(Airdrop.Airdrop__AlreadyStarted.selector);
        _airdrop.addUserAmount(user, 100);
    }

    function testRevert__airdrop__addUserAmount__whenIsPaused() public {
        vm.prank(_protocolMaintainer);
        _airdrop.pause();
        vm.expectRevert(bytes("Pausable: paused"));
        vm.prank(_airdropAccessor);
        _airdrop.addUserAmount(user, 100);
    }

    function test__airdrop__addUserAmount() public {
        uint256 totalValueBefore = _airdrop.totalValue();
        vm.prank(_airdropAccessor);
        _airdrop.addUserAmount(user, 100);
        assertEq(_airdrop.userInfo(user), 100);
        assertEq(_airdrop.totalValue(), totalValueBefore + 100);
    }
}

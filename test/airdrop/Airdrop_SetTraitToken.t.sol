// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AirdropTest} from "test/airdrop/AirdropTest.t.sol";
import {Airdrop} from "contracts/Airdrop.sol";

contract Airdrop_SetTraitToken is AirdropTest {
    function testRevert_when_not_owner() public {
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        airdrop.setTraitToken(address(trait));
    }

    function testRevert_if_traitToken_is_zero() public {
        vm.prank(owner);
        vm.expectRevert(Airdrop.Airdrop__AddressZero.selector);
        airdrop.setTraitToken(address(0));
    }

    function test_SetTraitToken() public {
        vm.prank(owner);
        airdrop.setTraitToken(address(trait));
        assertEq(address(airdrop.traitToken()), address(trait));
    }
}

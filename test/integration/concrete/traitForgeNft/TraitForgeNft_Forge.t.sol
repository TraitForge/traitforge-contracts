// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { TraitForgeNftTest } from "test/integration/concrete/traitForgeNft/TraitForgeNftTest.t.sol";
import { TraitForgeNft } from "contracts/TraitForgeNft.sol";
import { console } from "@forge-std/console.sol";

contract TraitForgeNft_Forge is TraitForgeNftTest {
    address public newOwner = makeAddr("newOwner");

    function testRevert_traitForgeNft_forge_whenPaused() public {
        vm.prank(_protocolMaintainer);
        _traitForgeNft.pause();

        vm.expectRevert(bytes("Pausable: paused"));
        vm.prank(address(_entityForging));
        _traitForgeNft.forge(newOwner, 1, 2, "");
    }

    function testRevert_traitForgeNft_forge_whenCallerNotEntityForging() public {
        vm.prank(user);
        vm.expectRevert(abi.encodeWithSelector(TraitForgeNft.TraitForgeNft__OnlyEntityForgingAuthorized.selector, user));
        _traitForgeNft.forge(newOwner, 1, 2, "");
    }

    function testRevert_traitForgeNft_forge_whenForgeWithSameTokens() public {
        vm.expectRevert(TraitForgeNft.TraitForgeNft__CannotForgeWithSameToken.selector);
        vm.prank(address(_entityForging));
        _traitForgeNft.forge(newOwner, 1, 1, "");
    }

    function testRevert_traitForgeNft_forge_whenNewGenerationCreatedOverMaxGeneration() public {
        vm.prank(_protocolMaintainer);
        _traitForgeNft.setMaxGeneration(1);

        // We mint some tokens
        _skipWhitelistTime();
        vm.prank(user);
        _traitForgeNft.mintWithBudget{ value: 0.5 ether }(new bytes32[](0), 1);

        vm.expectRevert(TraitForgeNft.TraitForgeNft__NewGenerationCreatedOverMaxGeneration.selector);
        vm.prank(address(_entityForging));
        _traitForgeNft.forge(newOwner, 1, 2, "");
    }

    function test_traitForgeNft_Forge() public {
        // We mint some tokens
        _skipWhitelistTime();
        vm.prank(user);
        _traitForgeNft.mintWithBudget{ value: 0.5 ether }(new bytes32[](0), 1);

        vm.prank(address(_entityForging));
        _traitForgeNft.forge(newOwner, 1, 2, "");
        assertEq(_traitForgeNft.balanceOf(newOwner), 1);
    }
}

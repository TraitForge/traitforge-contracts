// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { TraitForgeNftTest } from "test/integration/concrete/traitForgeNft/TraitForgeNftTest.t.sol";
import { TraitForgeNft } from "contracts/TraitForgeNft.sol";
import { console } from "@forge-std/console.sol";

contract TraitForgeNft_MintTokenWithBudget is TraitForgeNftTest {
    function testRevert_traitForgeNft_mintTokenWithBudget_whenPaused() public {
        _skipWhitelistTime();
        vm.prank(_protocolMaintainer);
        _traitForgeNft.pause();

        bytes32[] memory proofs = new bytes32[](0);
        vm.expectRevert(bytes("Pausable: paused"));
        vm.prank(user);
        _traitForgeNft.mintWithBudget{ value: 0.005 ether }(proofs, 1);
    }

    function testRevert_traitForgeNft_mintTokenWithBudget_whenNotWhitelisted() public {
        bytes32[] memory proofs = new bytes32[](0);
        vm.expectRevert(TraitForgeNft.TraitForgeNft__NotWhiteListed.selector);
        vm.prank(user);
        _traitForgeNft.mintWithBudget{ value: 0.005 ether }(proofs, 1);
    }

    function testRevert_traitForgeNft_mintTokenWithBudget_whenMinAmountMintedIsZero() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        vm.expectRevert(TraitForgeNft.TraitForgeNft__MinAmountIsZero.selector);
        vm.prank(user);
        _traitForgeNft.mintWithBudget{ value: 0.005 ether }(proofs, 0);
    }

    function testRevert_traitForgeNft_mintTokenWithBudget_whenAmountMintedIsLowerThanMinAmount() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        vm.expectRevert(TraitForgeNft.TraitForgeNft__NotEnoughTokensMinted.selector);
        vm.prank(user);
        _traitForgeNft.mintWithBudget{ value: 0.005 ether }(proofs, 2);
    }

    function testRevert_traitForgeNft_mintTokenWithBudget_whenMaxGenerationReached() public {
        _skipWhitelistTime();
        vm.prank(_protocolMaintainer);
        _traitForgeNft.setMaxGeneration(1);

        uint256 maxTokensPerGen = _traitForgeNft.maxTokensPerGen();
        bytes32[] memory proofs = new bytes32[](0);
        vm.expectRevert(TraitForgeNft.TraitForgeNft__MaxGenerationReached.selector);
        vm.prank(user);
        _traitForgeNft.mintWithBudget{ value: 2500 ether }(proofs, maxTokensPerGen + 1);
    }

    function test_traitForgeNft_mintTokenWithBudget() public {
        _skipWhitelistTime();

        bytes32[] memory proofs = new bytes32[](0);
        vm.prank(user);
        _traitForgeNft.mintWithBudget{ value: 10 ether }(proofs, 20);
        assertGt(_traitForgeNft.totalSupply(), 20);
        assertGt(_traitForgeNft.balanceOf(user), 20);
    }
}

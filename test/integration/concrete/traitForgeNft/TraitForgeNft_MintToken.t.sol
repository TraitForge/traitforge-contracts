// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { TraitForgeNftTest } from "test/integration/concrete/traitForgeNft/TraitForgeNftTest.t.sol";
import { TraitForgeNft } from "contracts/TraitForgeNft.sol";
import { console } from "@forge-std/console.sol";

contract TraitForgeNft_MintToken is TraitForgeNftTest {
    function testRevert_traitForgeNft_mintToken_whenPaused() public {
        _skipWhitelistTime();
        vm.prank(_protocolMaintainer);
        _traitForgeNft.pause();

        bytes32[] memory proofs = new bytes32[](0);
        vm.expectRevert(bytes("Pausable: paused"));
        vm.prank(user);
        _traitForgeNft.mintToken{ value: 0.005 ether }(proofs);
    }

    function testRevert_traitForgeNft_mintToken_whenNotWhitelisted() public {
        bytes32[] memory proofs = new bytes32[](0);
        vm.expectRevert(TraitForgeNft.TraitForgeNft__NotWhiteListed.selector);
        vm.prank(user);
        _traitForgeNft.mintToken{ value: 0.005 ether }(proofs);
    }

    function testRevert_traitForgeNft_mintToken_whenNotEnoughEthSent() public {
        _skipWhitelistTime();

        bytes32[] memory proofs = new bytes32[](0);
        vm.expectRevert(TraitForgeNft.TraitForgeNft__InsufficientETHSent.selector);
        vm.prank(user);
        _traitForgeNft.mintToken{ value: 0.001 ether }(proofs);
    }

    function testRevert_traitForgeNft_mintToken_whenMaxGenerationReached() public {
        _skipWhitelistTime();
        vm.prank(_protocolMaintainer);
        _traitForgeNft.setMaxGeneration(1);

        bytes32[] memory proofs = new bytes32[](0);
        for (uint256 i = 0; i < _traitForgeNft.maxTokensPerGen(); i++) {
            uint256 price = _traitForgeNft.calculateMintPrice();
            vm.prank(user);
            _traitForgeNft.mintToken{ value: price }(proofs);
        }
        uint256 lastPrice = _traitForgeNft.calculateMintPrice();
        vm.expectRevert(TraitForgeNft.TraitForgeNft__MaxGenerationReached.selector);
        vm.prank(user);
        _traitForgeNft.mintToken{ value: lastPrice }(proofs);
    }

    function test_traitForgeNft_mintToken() public {
        _skipWhitelistTime();

        bytes32[] memory proofs = new bytes32[](0);
        uint256 price = _traitForgeNft.calculateMintPrice();
        vm.prank(user);
        _traitForgeNft.mintToken{ value: price }(proofs);
        uint256 fees = _nukeFund.taxCut() * price / 10_000; //_nukeFund.BPS();
        assertEq(_traitForgeNft.totalSupply(), 1);
        assertEq(_traitForgeNft.balanceOf(user), 1);
        assertEq(address(_nukeFund).balance, price - fees);
        assertEq(_nukeFund.ethCollector().balance, fees); // airdrop has not started yet && totalDevWeight == 0
    }
}

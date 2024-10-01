// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { EntityForgingTest } from "test/integration/concrete/entityForging/EntityForgingTest.t.sol";
import { EntityForging } from "contracts/EntityForging.sol";

contract EntityForgingTest_ForgeWithListed is EntityForgingTest {
    uint256 fee = 0.02 ether;

    function testRevert_entityForging_forgeWithListed_whenPaused() public {
        vm.prank(_protocolMaintainer);
        _entityForging.pause();

        vm.expectRevert(bytes("Pausable: paused"));
        vm.prank(_randomUser);
        _entityForging.forgeWithListed(1, 2);
    }

    function testRevert_entityForging_forgeWithListed_whenForgeTokenIdNotListed() public {
        vm.expectRevert(EntityForging.EntityForging__ForgerTokenIdNotListed.selector);
        vm.prank(_randomUser);
        _entityForging.forgeWithListed(1, 2);
    }

    function testRevert_entityForging_forgeWithListed_whenMergerTokenIdIsZero() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        uint256 price = _traitForgeNft.calculateMintPrice();
        vm.startPrank(user);
        _traitForgeNft.mintToken{ value: price }(proofs);
        _entityForging.listForForging(1, fee);

        vm.expectRevert(EntityForging.EntityForging__MergerTokenIdIsZero.selector);
        _entityForging.forgeWithListed(1, 0);
    }

    function testRevert_entityForging_forgeWithListed_whenMergerTokenIdNotOwnByCaller() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        uint256 price1 = _traitForgeNft.calculateMintPrice();
        vm.startPrank(user);
        _traitForgeNft.mintToken{ value: price1 }(proofs);
        _entityForging.listForForging(1, fee);
        vm.stopPrank();

        uint256 price2 = _traitForgeNft.calculateMintPrice();
        vm.prank(otherUser);
        _traitForgeNft.mintToken{ value: price2 }(proofs);

        vm.prank(user);
        vm.expectRevert(EntityForging.EntityForging__MergerTokenNotOwnedByCaller.selector);
        _entityForging.forgeWithListed(1, 2);
    }

    function testRevert_entityForging_forgeWithListed_whenTokensNotSameGeneration() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        uint256 maxTokensPerGen = _traitForgeNft.maxTokensPerGen();
        for (uint256 i = 0; i < maxTokensPerGen; i++) {
            uint256 price = _traitForgeNft.calculateMintPrice();
            vm.prank(user);
            _traitForgeNft.mintToken{ value: price }(proofs);
        }
        vm.prank(user);
        _entityForging.listForForging(1, fee);

        uint256 price1 = _traitForgeNft.calculateMintPrice();
        vm.prank(user);
        _traitForgeNft.mintToken{ value: price1 }(proofs);

        vm.prank(user);
        vm.expectRevert(EntityForging.EntityForging__TokensNotSameGeneration.selector);
        _entityForging.forgeWithListed(1, 10_001);
    }

    function testRevert_entityForging_forgeWithListed_whenFeeMismatchWithEthSent() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        uint256 price1 = _traitForgeNft.calculateMintPrice();
        vm.startPrank(user);
        _traitForgeNft.mintToken{ value: price1 }(proofs);
        _entityForging.listForForging(1, fee);

        uint256 price2 = _traitForgeNft.calculateMintPrice();
        _traitForgeNft.mintToken{ value: price2 }(proofs);

        vm.expectRevert(EntityForging.EntityForging__FeeMismatchWithEthSent.selector);
        _entityForging.forgeWithListed{ value: fee + 1 }(1, 2);
    }

    function testRevert_entityForging_forgeWithListed_whenTokensAlreadyForged() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        uint256 price1 = _traitForgeNft.calculateMintPrice();
        vm.startPrank(user);
        _traitForgeNft.mintToken{ value: price1 }(proofs);
        _entityForging.listForForging(1, fee);

        uint256 price2 = _traitForgeNft.calculateMintPrice();
        _traitForgeNft.mintToken{ value: price2 }(proofs);

        _entityForging.forgeWithListed{ value: fee }(1, 2);
        _entityForging.listForForging(1, fee);

        vm.expectRevert(EntityForging.EntityForging__TokensAlreadyForged.selector);
        _entityForging.forgeWithListed{ value: fee }(1, 2);
    }

    function testRevert_entityForging_forgeWithListed_whenMergerIdEntropyCannotMerge() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        uint256 price1 = _traitForgeNft.calculateMintPrice();
        vm.startPrank(user);
        _traitForgeNft.mintToken{ value: price1 }(proofs);
        _entityForging.listForForging(1, fee);

        for (uint256 i = 0; i < 3; i++) {
            uint256 price = _traitForgeNft.calculateMintPrice();
            _traitForgeNft.mintToken{ value: price }(proofs);
        }

        vm.expectRevert(EntityForging.EntityForging__MergerEntropyCannotMerge.selector);
        _entityForging.forgeWithListed{ value: fee }(1, 4); // the entropy of token 4 is not a merger
    }
}

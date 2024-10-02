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
        _mintNFTs(user, 10);
        uint256 forgerId = _getTheNthForgerId(0, 10, 1);

        vm.startPrank(user);
        _entityForging.listForForging(forgerId, fee);

        vm.expectRevert(EntityForging.EntityForging__MergerTokenIdIsZero.selector);
        _entityForging.forgeWithListed(forgerId, 0);
    }

    function testRevert_entityForging_forgeWithListed_whenMergerTokenIdNotOwnByCaller() public {
        _mintNFTs(user, 4000); // mint first 10 tokens to user
        uint256 forgerId = _getTheNthForgerId(0, 4000, 1);

        vm.prank(user);
        _entityForging.listForForging(forgerId, fee);

        _mintNFTs(otherUser, 4000); // mint next 10 tokens to otherUser
        uint256 mergerId = _getTheNthMergerId(4000, 8000, 1);

        vm.prank(user);
        vm.expectRevert(EntityForging.EntityForging__MergerTokenNotOwnedByCaller.selector);
        _entityForging.forgeWithListed(forgerId, mergerId);
    }

    function testRevert_entityForging_forgeWithListed_whenTokensNotSameGeneration() public {
        uint256 maxTokensPerGen = _traitForgeNft.maxTokensPerGen();
        _mintNFTs(user, maxTokensPerGen * 2);
        uint256 forgerId = _getTheNthForgerId(0, maxTokensPerGen, 1);
        vm.prank(user);
        _entityForging.listForForging(forgerId, fee);

        uint256 mergerId = _getTheNthMergerId(maxTokensPerGen, maxTokensPerGen * 2, 1);

        vm.prank(user);
        vm.expectRevert(EntityForging.EntityForging__TokensNotSameGeneration.selector);
        _entityForging.forgeWithListed(forgerId, mergerId);
    }

    function testRevert_entityForging_forgeWithListed_whenFeeMismatchWithEthSent() public {
        uint256 maxTokensPerGen = _traitForgeNft.maxTokensPerGen();
        _mintNFTs(user, maxTokensPerGen);
        uint256 forgerId = _getTheNthForgerId(0, maxTokensPerGen, 1);

        vm.startPrank(user);
        _entityForging.listForForging(forgerId, fee);

        uint256 mergerId = _getTheNthMergerId(0, maxTokensPerGen, 1);
        vm.expectRevert(EntityForging.EntityForging__FeeMismatchWithEthSent.selector);
        _entityForging.forgeWithListed{ value: fee + 1 }(forgerId, mergerId);
    }

    function testRevert_entityForging_forgeWithListed_whenTokensAlreadyForged() public {
        uint256 maxTokensPerGen = _traitForgeNft.maxTokensPerGen();
        _mintNFTs(user, maxTokensPerGen);
        uint256 forgerId = _getTheNthForgerId(0, maxTokensPerGen, 1);
        uint256 mergerId = _getTheNthMergerId(0, maxTokensPerGen, 1);

        vm.startPrank(user);
        _entityForging.listForForging(forgerId, fee);
        _entityForging.forgeWithListed{ value: fee }(forgerId, mergerId);
        _entityForging.listForForging(forgerId, fee);

        vm.expectRevert(EntityForging.EntityForging__TokensAlreadyForged.selector);
        _entityForging.forgeWithListed{ value: fee }(forgerId, mergerId);
    }

    function testRevert_entityForging_forgeWithListed_whenMergerIdEntropyCannotMerge() public {
        uint256 maxTokensPerGen = _traitForgeNft.maxTokensPerGen();
        _mintNFTs(user, maxTokensPerGen);
        uint256 forgerId = _getTheNthForgerId(0, maxTokensPerGen, 1);
        uint256 secondForgerId = _getTheNthForgerId(0, maxTokensPerGen, 2);

        vm.startPrank(user);
        _entityForging.listForForging(forgerId, fee);

        vm.expectRevert(EntityForging.EntityForging__MergerEntropyCannotMerge.selector);
        _entityForging.forgeWithListed{ value: fee }(forgerId, secondForgerId);
    }

    function testRevert_entityForging_forgeWithListed_whenInsufficientMergerForgePotential() public {
        uint256 maxTokensPerGen = _traitForgeNft.maxTokensPerGen();
        _mintNFTs(user, maxTokensPerGen);
        uint256 mergerId = _getTheNthMergerId(0, maxTokensPerGen, 1);
        uint256[] memory forgerIds = new uint256[](10);
        for (uint256 i; forgerIds.length > i; i++) {
            forgerIds[i] = _getTheNthForgerId(0, maxTokensPerGen, i + 1);
            vm.prank(user);
            _entityForging.listForForging(_getTheNthForgerId(0, maxTokensPerGen, i + 1), fee);
        }

        for (uint256 i = 0; i < forgerIds.length; i++) {
            uint8 mergerForgePotential = uint8((_traitForgeNft.getTokenEntropy(mergerId) / 10) % 10);
            if (!(mergerForgePotential > 0 && _entityForging.forgingCounts(mergerId) + 1 <= mergerForgePotential)) {
                vm.expectRevert(EntityForging.EntityForging__InsufficientMergerForgePotential.selector);
            }
            vm.prank(user);
            _entityForging.forgeWithListed{ value: fee }(forgerIds[i], mergerId);
        }
    }

    function test_entityForging_forgeWithListed() public {
        _mintNFTs(user, 1000);
        uint256 forgerId = _getTheNthForgerId(0, 1000, 1);
        uint256 mergerId = _getTheNthMergerId(0, 1000, 1);
        vm.startPrank(user);
        _entityForging.listForForging(forgerId, fee);
        uint256 forgedTokenId = _entityForging.forgeWithListed{ value: fee }(forgerId, mergerId);

        assertEq(_traitForgeNft.getTokenGeneration(forgedTokenId), 2);
        assertEq(_entityForging.forgingCounts(forgerId), 1);
        assertEq(_entityForging.forgingCounts(mergerId), 1);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { EntityForgingTest } from "test/integration/concrete/entityForging/EntityForgingTest.t.sol";
import { EntityForging } from "contracts/EntityForging.sol";

contract EntityForgingTest_ListForForging is EntityForgingTest {
    uint256 fee;

    function testRevert_entityForging_listForForging_whenPaused() public {
        vm.prank(_protocolMaintainer);
        _entityForging.pause();

        fee = _traitForgeNft.calculateMintPrice();
        vm.expectRevert(bytes("Pausable: paused"));
        vm.prank(_randomUser);
        _entityForging.listForForging(1, fee);
    }

    function testRevert_entityForging_listForForging_whenTokenAlreadyListed() public {
        _mintTraitForgeNft(user, 1000);
        uint256 forgerId = _getTheNthForgerId(0, 1000, 1);

        fee = _traitForgeNft.calculateMintPrice();
        vm.startPrank(user);
        _entityForging.listForForging(forgerId, fee);

        fee = _traitForgeNft.calculateMintPrice();
        vm.expectRevert(EntityForging.EntityForging__TokenAlreadyListed.selector);
        _entityForging.listForForging(forgerId, fee);
    }

    function testRevert_entityForging_listForForging_whenCallerNotOwner() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        uint256 price = _traitForgeNft.calculateMintPrice();
        vm.prank(user);
        _traitForgeNft.mintToken{ value: price }(proofs);

        fee = _traitForgeNft.calculateMintPrice();

        vm.prank(_randomUser);
        vm.expectRevert(EntityForging.EntityForging__TokenNotOwnedByCaller.selector);
        _entityForging.listForForging(1, fee);
    }

    function testRevert_entityForging_listForForging_whenFeeTooLow() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        uint256 price = _traitForgeNft.calculateMintPrice();
        vm.prank(user);
        _traitForgeNft.mintToken{ value: price }(proofs);

        vm.prank(user);
        vm.expectRevert(EntityForging.EntityForging__FeeTooLow.selector);
        _entityForging.listForForging(1, 0);
    }

    function test_entityForging_listForForging() public {
        _mintTraitForgeNft(user, 1000);
        uint256 forgerId = _getTheNthForgerId(0, 1000, 1);

        fee = _traitForgeNft.calculateMintPrice();

        vm.startPrank(user);
        _entityForging.listForForging(forgerId, fee);
        uint256 listingCount = _entityForging.listingCount();
        EntityForging.Listing memory listing = _entityForging.getListings(listingCount);

        assertEq(listingCount, 1);
        assertEq(listing.account, user);
        assertEq(listing.tokenId, forgerId);
        assertEq(listing.isListed, true);
        assertEq(listing.fee, fee);
        assertEq(_entityForging.listedTokenIds(forgerId), listingCount);
    }
}

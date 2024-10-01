// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { EntityForgingTest } from "test/integration/concrete/entityForging/EntityForgingTest.t.sol";
import { EntityForging } from "contracts/EntityForging.sol";

contract EntityForgingTest_ListForForging is EntityForgingTest {
    uint256 fee = 0.02 ether;

    function testRevert_entityForging_listForForging_whenPaused() public {
        vm.prank(_protocolMaintainer);
        _entityForging.pause();

        vm.expectRevert(bytes("Pausable: paused"));
        vm.prank(_randomUser);
        _entityForging.listForForging(1, fee);
    }

    function testRevert_entityForging_listForForging_whenTokenAlreadyListed() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        uint256 price = _traitForgeNft.calculateMintPrice();
        vm.startPrank(user);
        _traitForgeNft.mintToken{ value: price }(proofs);

        _entityForging.listForForging(1, fee);

        vm.expectRevert(EntityForging.EntityForging__TokenAlreadyListed.selector);
        _entityForging.listForForging(1, fee);
    }

    function testRevert_entityForging_listForForging_whenCallerNotOwner() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        uint256 price = _traitForgeNft.calculateMintPrice();
        vm.prank(user);
        _traitForgeNft.mintToken{ value: price }(proofs);

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
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        uint256 price = _traitForgeNft.calculateMintPrice();
        vm.startPrank(user);
        _traitForgeNft.mintToken{ value: price }(proofs);

        _entityForging.listForForging(1, fee);
        uint256 listingCount = _entityForging.listingCount();
        EntityForging.Listing memory listing = _entityForging.getListings(listingCount);

        assertEq(listingCount, 1);
        assertEq(listing.account, user);
        assertEq(listing.tokenId, 1);
        assertEq(listing.isListed, true);
        assertEq(listing.fee, fee);
        assertEq(_entityForging.listedTokenIds(1), listingCount);
    }
}
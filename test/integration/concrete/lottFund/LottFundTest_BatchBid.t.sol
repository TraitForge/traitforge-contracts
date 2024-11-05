// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { LottFundTest } from "test/integration/concrete/lottFund/LottFundTest.t.sol";
import { LottFund } from "contracts/LottFund.sol";

contract LottFundTest_BatchBid is LottFundTest {
    function testRevert_lottFund_batchBid_whenPaused() public {
        vm.prank(_protocolMaintainer);
        _lottFund.pause();
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 1;

        vm.expectRevert(bytes("Pausable: paused"));
        vm.prank(_randomUser);
        _lottFund.batchBid(tokenIds);
    }

    function testRevert_lottFund_batchBid_whenPausedBids() public {
        vm.prank(_protocolMaintainer);
        _lottFund.setPausedBids(true);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 1;

        vm.expectRevert(LottFund.LottFund__BiddingIsPaused.selector);
        vm.prank(_randomUser);
        _lottFund.batchBid(tokenIds);
    }

    function testRevert_lottFund_batchBid_whenCallerAddressHasBiddedTwoManyTimes() public {
        uint256 maxBidsPerAddress = _lottFund.maxBidsPerAddress();
        _mintTraitForgeNft(user, 1000);
        uint256 tokenIdWithMaxBidPotential;
        uint256[] memory tokenIds = new uint256[](maxBidsPerAddress + 1);
        for (uint256 i = 0; i < maxBidsPerAddress; i++) {
            tokenIdWithMaxBidPotential = _getTheNthMaxBidPotentialNotZeroId(0, 1000, i + 1);
            tokenIds[i] = tokenIdWithMaxBidPotential;
        }
        vm.startPrank(user);
        _traitForgeNft.setApprovalForAll(address(_lottFund), true);

        tokenIdWithMaxBidPotential = _getTheNthMaxBidPotentialNotZeroId(0, 1000, maxBidsPerAddress + 1);
        tokenIds[maxBidsPerAddress] = tokenIdWithMaxBidPotential;
        vm.expectRevert(abi.encodeWithSelector(LottFund.LottFund__AddressHasBiddedTooManyTimes.selector, user));
        _lottFund.batchBid(tokenIds);
        vm.stopPrank();
    }

    function testRevert_lottFund_batchBid_whenCallerNotTokenOwner() public {
        address otherUser = makeAddr("otherUser");
        _mintTraitForgeNft(otherUser, 1);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 1;
        vm.expectRevert(LottFund.LottFund__CallerNotTokenOwner.selector);
        vm.prank(user);
        _lottFund.batchBid(tokenIds);
    }

    function testRevert_lottFund_batchBid_whenContractNotApproved() public {
        _mintTraitForgeNft(user, 1);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 1;

        vm.expectRevert(LottFund.LottFund__ContractNotApproved.selector);
        vm.prank(user);
        _lottFund.batchBid(tokenIds);
    }

    function testRevert_lottFund_batchBid_whenMaxBidPotentialIsZero() public {
        _mintTraitForgeNft(user, 100);
        uint256 tokenIdWithMaxBidPotentialZero = _getTheNthMaxBidPotentialIsZeroId(0, 100, 1);
        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = tokenIdWithMaxBidPotentialZero;

        vm.startPrank(user);
        _traitForgeNft.approve(address(_lottFund), tokenIdWithMaxBidPotentialZero);
        vm.expectRevert(LottFund.LottFund__TokenCannotBeBidded.selector);
        _lottFund.batchBid(tokenIds);
    }

    function testRevert_lottFund_batchBid_whenTokenBidCountHigherThanPotential() public {
        _mintTraitForgeNft(user, 100);
        uint256 tokenIdWithMaxBidPotential = _getTheNthMaxBidPotentialNotZeroId(0, 100, 1);
        uint256 tokenMaxBidPotential = _lottFund.getMaxBidPotential(tokenIdWithMaxBidPotential);
        uint256[] memory tokenIds = new uint256[](tokenMaxBidPotential + 1);

        vm.startPrank(user);
        _traitForgeNft.setApprovalForAll(address(_lottFund), true);
        for (uint256 i = 0; i <= tokenMaxBidPotential; i++) {
            tokenIds[i] = tokenIdWithMaxBidPotential;
        }

        vm.expectRevert(LottFund.LottFund__TokenCannotBeBidded.selector);
        _lottFund.batchBid(tokenIds);
    }

    function test_lottFund_batchBid() public {
        _mintTraitForgeNft(user, 100);
        uint256 tokenToBidCount = 10;
        uint256[] memory tokenIds = new uint256[](tokenToBidCount);
        for (uint256 i = 0; i < tokenToBidCount; i++) {
            tokenIds[i] = _getTheNthMaxBidPotentialNotZeroId(0, 100, i + 1);
        }

        vm.startPrank(user);
        _traitForgeNft.setApprovalForAll(address(_lottFund), true);
        _lottFund.batchBid(tokenIds);

        assertEq(_lottFund.bidCountPerRound(_lottFund.currentRound(), user), tokenToBidCount);
        assertEq(_lottFund.bidsAmount(), tokenToBidCount);
        for (uint256 i = 0; i < tokenToBidCount; i++) {
            assertEq(_lottFund.tokenIdsBidded(i), tokenIds[i]);
            assertEq(_lottFund.tokenBidCount(tokenIds[i]), 1);
        }
    }
}

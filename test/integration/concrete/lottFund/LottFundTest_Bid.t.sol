// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { LottFundTest } from "test/integration/concrete/lottFund/LottFundTest.t.sol";
import { LottFund } from "contracts/LottFund.sol";

contract LottFundTest_Bid is LottFundTest {
    function testRevert_lottFund_bid_whenPaused() public {
        vm.prank(_protocolMaintainer);
        _lottFund.pause();

        vm.expectRevert(bytes("Pausable: paused"));
        vm.prank(_randomUser);
        _lottFund.bid(1);
    }

    function testRevert_lottFund_bid_whenCallerAddressHasBiddedTwoManyTimes() public {
        uint256 maxBidsPerAddress = _lottFund.maxBidsPerAddress();
        _mintTraitForgeNft(user, 1000);
        uint256 tokenIdWithMaxBidPotential;
        for (uint256 i = 0; i < maxBidsPerAddress; i++) {
            tokenIdWithMaxBidPotential = _getTheNthMaxBidPotentialNotZeroId(0, 1000, i + 1);

            vm.startPrank(user);
            _traitForgeNft.approve(address(_lottFund), tokenIdWithMaxBidPotential);
            _lottFund.bid(tokenIdWithMaxBidPotential);
            vm.stopPrank();
        }

        tokenIdWithMaxBidPotential = _getTheNthMaxBidPotentialNotZeroId(0, 1000, maxBidsPerAddress + 1);

        vm.startPrank(user);
        _traitForgeNft.approve(address(_lottFund), tokenIdWithMaxBidPotential);
        vm.expectRevert(abi.encodeWithSelector(LottFund.LottFund__AddressHasBiddedTooManyTimes.selector, user));
        _lottFund.bid(tokenIdWithMaxBidPotential);
        vm.stopPrank();
    }

    function testRevert_lottFund_bid_whenCallerNotTokenOwner() public {
        address otherUser = makeAddr("otherUser");
        _mintTraitForgeNft(otherUser, 1);

        vm.expectRevert(LottFund.LottFund__CallerNotTokenOwner.selector);
        vm.prank(user);
        _lottFund.bid(1);
    }

    function testRevert_lottFund_bid_whenContractNotApproved() public {
        _mintTraitForgeNft(user, 1);

        vm.expectRevert(LottFund.LottFund__ContractNotApproved.selector);
        vm.prank(user);
        _lottFund.bid(1);
    }

    function testRevert_lottFund_bid_whenMaxBidPotentialIsZero() public {
        _mintTraitForgeNft(user, 100);
        uint256 tokenIdWithMaxBidPotentialZero = _getTheNthMaxBidPotentialIsZeroId(0, 100, 1);

        vm.startPrank(user);
        _traitForgeNft.approve(address(_lottFund), tokenIdWithMaxBidPotentialZero);
        vm.expectRevert(LottFund.LottFund__TokenCannotBeBidded.selector);
        _lottFund.bid(tokenIdWithMaxBidPotentialZero);
    }

    function testRevert_lottFund_bid_whenTokenBidCountHigherThanPotential() public {
        _mintTraitForgeNft(user, 100);
        uint256 tokenIdWithMaxBidPotential = _getTheNthMaxBidPotentialNotZeroId(0, 100, 1);
        uint256 tokenMaxBidPotential = _lottFund.getMaxBidPotential(tokenIdWithMaxBidPotential);

        vm.startPrank(user);
        _traitForgeNft.approve(address(_lottFund), tokenIdWithMaxBidPotential);
        for (uint256 i = 0; i < tokenMaxBidPotential; i++) {
            _lottFund.bid(tokenIdWithMaxBidPotential);
        }

        vm.expectRevert(LottFund.LottFund__TokenCannotBeBidded.selector);
        _lottFund.bid(tokenIdWithMaxBidPotential);
    }

    function test_lottFund_bid() public {
        _mintTraitForgeNft(user, 100);
        uint256 tokenIdWithMaxBidPotential = _getTheNthMaxBidPotentialNotZeroId(0, 100, 1);

        vm.startPrank(user);
        _traitForgeNft.approve(address(_lottFund), tokenIdWithMaxBidPotential);
        _lottFund.bid(tokenIdWithMaxBidPotential);

        assertEq(_lottFund.bidCountPerRound(_lottFund.currentRound(), user), 1);
        assertEq(_lottFund.bidsAmount(), 1);
        assertEq(_lottFund.tokenIdsBidded(0), tokenIdWithMaxBidPotential);
        assertEq(_lottFund.tokenBidCount(tokenIdWithMaxBidPotential), 1);
    }
}

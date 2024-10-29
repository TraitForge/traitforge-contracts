// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { LottFundTest } from "test/integration/concrete/lottFund/LottFundTest.t.sol";
import { LottFund } from "contracts/LottFund.sol";

contract LottFundTest_BidPayout is LottFundTest {
    uint8 constant MAX_BID_AMOUNT = 20;

    function setUp() public override {
        super.setUp();
        // calling the request random words function to set the random words
        uint256 maxBidAmount = _lottFund.maxBidAmount();
        for (uint256 i = 0; i < maxBidAmount; i++) {
            address bidder = makeAddr(string(abi.encodePacked("bidder", i)));
            _mintTraitForgeNft(bidder, MAX_BID_AMOUNT);
            vm.startPrank(bidder);
            uint256 tokenIdWithMaxBidPotential =
                _getTheNthMaxBidPotentialNotZeroId(i * MAX_BID_AMOUNT, MAX_BID_AMOUNT * (i + 1), 1);
            _traitForgeNft.approve(address(_lottFund), tokenIdWithMaxBidPotential);
            _lottFund.bid(tokenIdWithMaxBidPotential);
            vm.stopPrank();
        }
        assertEq(_lottFund.pausedBids(), true);
    }

    function test_lottFund_bidPayout() public {
        uint256 lastRequestId = _lottFund.lastRequestId();

        vm.prank(user);
        _vrfCoordinator.fulfillRandomWords(lastRequestId, address(_lottFund));
    }
}

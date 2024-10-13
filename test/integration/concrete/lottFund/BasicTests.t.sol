// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/LottFund.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol"; 

contract LottFundTest is Test {
    LottFund lottFund;
    address nukeFund = address(0x123);
    address lottFundAddr = address(0x456);
    address ethCollector = address(0x789);
    address owner = address(this); 
    address user1 = address(0x1111);
    address user2 = address(0x2222);
    uint256 subscriptionId = 1;
    VRFCoordinatorV2Mock vrfCoordinator;

    function setUp() public {
        // Deploying the mocked VRFCoordinator for testing
        vrfCoordinator = new VRFCoordinatorV2Mock(0.1 ether, 0.1 ether);
        // Deploy the contract with the mocked VRFCoordinator
        lottFund = new LottFund(
            address(vrfCoordinator),
            ethCollector,
            nukeFund,
            subscriptionId
        );
    }

    function testConstructorRevertsWithZeroAddress() public {
        vm.expectRevert("NukeFund address cannot be zero");
        new LottFund(
            address(vrfCoordinator),
            ethCollector,
            address(0),
            subscriptionId
        );
    }

    function testConstructorInitializesProperly() public {
        assertEq(lottFund.nukeFundAddress(), nukeFund);
        assertEq(lottFund.getFundBalance(), 0);
        assertEq(lottFund.ethCollector(), ethCollector);
    }

        function testBidRevertsIfNotTokenOwner() public {
        vm.prank(user2);
        vm.expectRevert(LottFund.LottFund__CallerNotTokenOwner.selector);
        lottFund.bid(1);
    }

    function testBidIncreasesBidsAmount() public {
        // Assuming user1 owns a token and has approved the contract
        vm.prank(user1);
        lottFund.bid(1);

        // Check that the bidsAmount increased
        assertEq(lottFund.bidsAmount(), 1);
        assertEq(lottFund.getTokenBidAmounts(1), 1);
    }

    function testBidRevertsIfMaxBidsReached() public {
        // Simulate reaching the max bids amount
        for (uint256 i = 0; i < lottFund.maxBidAmount(); i++) {
            vm.prank(user1);
            lottFund.bid(i + 1);
        }

        vm.prank(user1);
        vm.expectRevert(LottFund.LottFund__BiddingNotFinished.selector);
        lottFund.bid(100);
    }

        function testReceiveFunction() public {
        vm.deal(user1, 10 ether);
        vm.prank(user1); 
        (bool success, ) = address(lottFund).call{value: 1 ether}("");
        assert(success);

        uint256 devShare = (1 ether * lottFund.taxCut()) / lottFund.BPS();
        assertEq(address(lottFund).balance, 1 ether - devShare);
    }

    function testReceiveRevertsIfNoETH() public {
        vm.expectRevert();
        vm.prank(user1);
        (bool success, ) = address(lottFund).call("");
        assert(!success);
    }

    function testPauseAndUnpause() public {
        lottFund.pause();
        assertTrue(lottFund.paused());

        vm.expectRevert("Pausable: paused");
        vm.prank(user1);
        lottFund.bid(1);

        lottFund.unpause();
        assertFalse(lottFund.paused());
    }

    function testSetNativePayment() public {
        lottFund.setNativePayment(false);
        assertFalse(lottFund.nativePayment());

        lottFund.setNativePayment(true);
        assertTrue(lottFund.nativePayment());
    }

    function testSetNativePaymentRevertsIfSameValue() public {
        vm.expectRevert("Native payment already set to this value");
        lottFund.setNativePayment(true); 
    }

    function testRequestRandomWords() public {
        uint256 requestId = lottFund.requestRandomWords(true);
        assertEq(lottFund.lastRequestId(), requestId);

        uint256;
        randomWords[0] = 42;
        vrfCoordinator.fulfillRandomWords(requestId, address(lottFund), randomWords);

        (bool fulfilled, ) = lottFund.getRequestStatus(requestId);
        assertTrue(fulfilled);
    }

    function testBurnTokens() public { 
        uint256;
        for (uint256 i = 0; i < 5; i++) {
            tokenIds[i] = i + 1;
        }

        lottFund.burnTokens(tokenIds);
    }

    function testSetMaxBidAmount() public {
        uint256 newMax = 2000;
        lottFund.setMaxBidAmount(newMax);
        assertEq(lottFund.maxBidAmount(), newMax);
    }

    function testSetMaxBidAmountRevertsIfNotMaintainer() public {
        vm.prank(user1);
        vm.expectRevert("Not authorized");
        lottFund.setMaxBidAmount(2000);
    }

    function testSetNukeFundAddress() public {
        address newAddress = address(0x987);
        lottFund.setNukeFundAddress(newAddress);
        assertEq(lottFund.nukeFundAddress(), newAddress);
    }
}









// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/LottFund.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract LottFundTest is Test {
    LottFund lottFund;
    address nukeFundAddress = address(0x123);
    address devFundAddress = address(0x456);
    address daoFundAddress = address(0x789);
    address ethCollector = address(0xabc);
    address user = address(0x1111);
    address user2 = address(0x2222);

    // State variables for tests
    uint256 public subscriptionId = 1;

    function setUp() public {
        // Mock AddressProvider
        AddressProviderResolver addressProvider = new MockAddressProvider(devFundAddress, daoFundAddress, nukeFundAddress);
        
        // Deploy LottFund
        lottFund = new LottFund(
            address(addressProvider),
            ethCollector,
            nukeFundAddress,
            subscriptionId
        );
        
        // Fund setup for testing
        vm.deal(user, 10 ether); // user has 10 ETH
        vm.deal(user2, 10 ether); // user2 has 10 ETH
    }

    function testReceiveFundsCorrectDistribution() public {
    // Send 1 ETH to the contract from user1
    uint256 amountSent = 1 ether;
    uint256 expectedDevShare = (amountSent * lottFund.taxCut()) / lottFund.BPS();
    uint256 expectedRemainingFund = amountSent - expectedDevShare;

    // Prank to simulate the user sending the ETH
    vm.prank(user);
    (bool success, ) = address(lottFund).call{value: amountSent}("");
    assertTrue(success);

    // Assert the funds are correctly split
    assertEq(address(lottFund).balance, expectedRemainingFund);
    
    // Check if devShare was sent to devFundAddress
    assertEq(address(devFundAddress).balance, expectedDevShare);

    // If the DAO fund should also receive funds, check its balance as well
    assertEq(address(daoFundAddress).balance, 0); // Assuming DAO Fund doesn't get share in this case
}

function testEthCollectorGetsShareWhenDaoFundNotAllowed() public {
    // Assuming airdropContract.daoFundAllowed() returns false in this case
    uint256 amountSent = 1 ether;
    uint256 expectedDevShare = (amountSent * lottFund.taxCut()) / lottFund.BPS();
    
    // Ensure that the dev share is sent to ethCollector
    vm.prank(user);
    (bool success, ) = address(lottFund).call{value: amountSent}("");
    assertTrue(success);

    // Assert ethCollector received the correct amount
    assertEq(address(ethCollector).balance, expectedDevShare);
}

function testNukeFundReceivesNothingIfNotAllowed() public {
    uint256 amountSent = 1 ether;

    // Simulate user sending funds
    vm.prank(user);
    (bool success, ) = address(lottFund).call{value: amountSent}("");
    assertTrue(success);

    // Ensure that nukeFundAddress gets nothing (depending on the test case logic)
    assertEq(address(nukeFundAddress).balance, 0);
}

function testFallbackFunctionCorrectDistribution() public {
    uint256 amountSent = 2 ether;
    uint256 expectedDevShare = (amountSent * lottFund.taxCut()) / lottFund.BPS();
    uint256 expectedRemainingFund = amountSent - expectedDevShare;

    // Use fallback to send ETH
    vm.prank(user);
    (bool success, ) = address(lottFund).call{value: amountSent}("");
    assertTrue(success);

    // Assert the funds are correctly split and balance is updated
    assertEq(address(lottFund).balance, expectedRemainingFund);
    assertEq(address(devFundAddress).balance, expectedDevShare);
}

function testSetNukeFundAddress() public {
    address newNukeFund = address(0x999);
    
    // Change the nuke fund address
    lottFund.setNukeFundAddress(newNukeFund);
    
    // Verify the new address
    assertEq(lottFund.nukeFundAddress(), newNukeFund);
}

function testReceiveZeroEthReverts() public {
    vm.expectRevert(); // Expect revert since no ETH is being sent
    vm.prank(user);
    (bool success, ) = address(lottFund).call{value: 0 ether}("");
    assertFalse(success); // Should fail
}

function testMaxAllowedClaimDivisor() public {
    uint256 amountSent = 5 ether;
    uint256 expectedClaimAmount = (amountSent / lottFund.maxAllowedClaimDivisor());

    vm.prank(user);
    (bool success, ) = address(lottFund).call{value: amountSent}("");
    assertTrue(success);

    assertEq(lottFund.getFundBalance(), expectedClaimAmount);
}
}

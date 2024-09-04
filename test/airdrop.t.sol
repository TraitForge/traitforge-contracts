// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/Airdrop/Airdrop.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TraitToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("TraitToken", "TRAIT") {
        _mint(msg.sender, initialSupply);
    }
}

contract AirdropTest is Test {
    Airdrop public airdrop;
    TraitToken public traitToken;
    address owner;
    address liquidityPool;
    address devAddress;
    address[] partnerAddresses;
    address[] referralAddresses;
    address user = address(0xABCD);
    address referrer = address(0xEF12);
    uint256 initialSupply = 10000000000 ether;  // 10 billion tokens

    function setUp() public {
        owner = address(this);
        traitToken = new TraitToken(initialSupply);

        // Deploy Airdrop contract
        airdrop = new Airdrop(owner);
        liquidityPool = vm.addr(1);
        devAddress = vm.addr(2);
        partnerAddresses.push(vm.addr(3));
        partnerAddresses.push(vm.addr(4));
        referralAddresses.push(referrer);

        // Set trait token and distribution addresses
        airdrop.setTraitToken(address(traitToken));

        // Transfer tokens to owner to test transferFrom
        traitToken.transfer(owner, initialSupply);

        // Approve the airdrop contract to spend the tokens
        traitToken.approve(address(airdrop), initialSupply);
    }

    function testSetTraitToken() public {
        assertEq(address(airdrop.traitToken()), address(traitToken), "Trait token address not set correctly");
    }

function testAddReferralInfo() public {
    // This should succeed before the airdrop starts
    airdrop.addReferralInfo(referrer, 5);
    assertEq(airdrop.referralInfo(referrer), 5, "Referral info not updated correctly");
    assertEq(airdrop.totalReferredMints(), 5, "Total referred mints not updated correctly");

    // Start the airdrop
    airdrop.startAirdrop(initialSupply);

    // This should revert because the airdrop has started
    vm.expectRevert("Already started");
    airdrop.addReferralInfo(referrer, 5);
}


    function testStartAirdropAndDistributeTokens() public {
        // Start the airdrop
        airdrop.startAirdrop(initialSupply);

        uint256 liquidityPoolShare = (initialSupply * 10) / 100;
        uint256 devShare = (initialSupply * 15) / 100;
        uint256 playersShare = (initialSupply * 55) / 100;
        uint256 referralShare = (initialSupply * 15) / 100;
        uint256 partnersShare = (initialSupply - liquidityPoolShare - devShare - playersShare - referralShare) / partnerAddresses.length;

        assertEq(traitToken.balanceOf(liquidityPool), liquidityPoolShare, "Liquidity pool share incorrect");
        assertEq(traitToken.balanceOf(devAddress), devShare, "Dev share incorrect");
        assertEq(airdrop.tokensToClaim(), playersShare, "Players share incorrect");
        assertEq(airdrop.tokensToClaimAsReferrer(), referralShare, "Referrer share incorrect");

        for (uint256 i = 0; i < partnerAddresses.length; i++) {
            assertEq(traitToken.balanceOf(partnerAddresses[i]), partnersShare, "Partners share incorrect");
        }
    }

    function testAddUserAmount() public {
        // Add user amount before airdrop starts
        airdrop.addUserAmount(user, 100);
        assertEq(airdrop.userInfo(user), 100);

        // Start the airdrop
        airdrop.startAirdrop(initialSupply);

        // This should revert because the airdrop has started
        vm.expectRevert("Already started");
        airdrop.addUserAmount(user, 50);
    }

    function testClaim() public {
        // Add user amount before airdrop starts
        airdrop.addUserAmount(user, 100);

        // Start the airdrop
        airdrop.startAirdrop(initialSupply);

        // User claims tokens
        vm.prank(user);
        airdrop.claim();

        uint256 amountClaimed = (airdrop.tokensToClaim() * 100) / 100;  // Since only one user with 100 tokens
        assertEq(traitToken.balanceOf(user), amountClaimed, "User claim amount incorrect");
        assertEq(airdrop.userInfo(user), 0, "User info not reset after claim");
    }

    function testClaimAsReferrer() public {
        // Add referral info before airdrop starts
        airdrop.addReferralInfo(referrer, 5);

        // Start the airdrop
        airdrop.startAirdrop(initialSupply);

        // Referrer claims tokens
        vm.prank(referrer);
        airdrop.claimAsReferrer();

        uint256 amountClaimed = (airdrop.tokensToClaimAsReferrer() * 5) / 5;  // Since only one referrer with 5 mints
        assertEq(traitToken.balanceOf(referrer), amountClaimed, "Referrer claim amount incorrect");
        assertEq(airdrop.referralInfo(referrer), 0, "Referral info not reset after claim");
    }

    function testMathEdgeCases() public {
        // Ensure no division by zero occurs
        airdrop.addUserAmount(user, 0);
        airdrop.startAirdrop(initialSupply);

        vm.prank(user);
        vm.expectRevert("Not eligible");
        airdrop.claim();

        // Test with maximum values
        uint256 maxAmount = type(uint256).max;
        airdrop.addUserAmount(user, maxAmount);
        assertEq(airdrop.userInfo(user), maxAmount, "Max user amount incorrect");
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { IAirdrop } from "contracts/interfaces/IAirdrop.sol";
import { IAddressProvider } from "contracts/interfaces/IAddressProvider.sol";
import { Roles } from "contracts/libraries/Roles.sol";
import { Errors } from "contracts/libraries/Errors.sol";
import { AddressProviderResolver } from "contracts/core/AddressProviderResolver.sol";

contract Airdrop is IAirdrop, AddressProviderResolver, ReentrancyGuard, Pausable {
    // Type declarations

    // Events

    // Modifiers

    // State variables
    bool private started;
    bool private daoAllowed;

    uint256 public totalTokenAmount;
    uint256 public totalValue;

    uint256 public totalReferredMints;
    uint256 public tokensToClaim;
    uint256 public tokensToClaimAsReferrer;

    address public liquidityPoolAddress;
    address public devAddress;
    address[] public partnerAddresses;

    uint256 private constant BPS = 10_000; // denominator of basis points

    uint256 public liquidityPoolRate = 1000;
    uint256 public devRate = 1500;
    uint256 public referralRate = 1500;
    uint256 public playersRate = 5500;

    mapping(address => uint256) public userInfo;
    mapping(address => uint256) public referralInfo;

    // Errors
    error Airdrop__AlreadyStarted();
    error Airdrop__InvalidAmount();
    error Airdrop__NotStarted();
    error Airdrop__AlreadyAllowed();
    error Airdrop__NotEligible();
    error Airdrop__AddressZero();
    error Airdrop__NothingToClaim();
    error Airdrop__PartnerAddressesNotSet();

    // Functions

    constructor(address addressProvider) AddressProviderResolver(addressProvider) { }

    /**
     * external & public functions *******************************
     */

    //////////////////////////// write functions ////////////////////////////

    // only accessible from NFT contract
    function startAirdrop(uint256 amount) external whenNotPaused nonReentrant onlyAirdropAccessor {
        if (started) revert Airdrop__AlreadyStarted();
        if (amount == 0) revert Airdrop__InvalidAmount();
        if (address(_getTraitToken()) == address(0)) revert Airdrop__AddressZero();
        started = true;
        _getTraitToken().transferFrom(msg.sender, address(this), amount);
        uint256 tokenTransfered = _distributeTokens(amount);
        totalTokenAmount = amount - tokenTransfered;
    }

    function allowDaoFund() external onlyAirdropAccessor {
        if (!started) revert Airdrop__NotStarted();
        if (daoAllowed) revert Airdrop__AlreadyAllowed();
        daoAllowed = true;
    }

    function addUserAmount(address user, uint256 amount) external whenNotPaused nonReentrant onlyAirdropAccessor {
        if (started) revert Airdrop__AlreadyStarted();
        userInfo[user] += amount;
        totalValue += amount;
    }

    function subUserAmount(address user, uint256 amount) external whenNotPaused nonReentrant onlyAirdropAccessor {
        if (started) revert Airdrop__AlreadyStarted();
        if (userInfo[user] < amount) revert Airdrop__InvalidAmount();
        userInfo[user] -= amount;
        totalValue -= amount;
    }

    function claim() external whenNotPaused nonReentrant {
        if (!started) revert Airdrop__NotStarted();
        if (userInfo[msg.sender] <= 0) revert Airdrop__NotEligible();

        uint256 amount = (totalTokenAmount * userInfo[msg.sender]) / totalValue;
        _getTraitToken().transfer(msg.sender, amount);
        userInfo[msg.sender] = 0;
    }

    function claimAsReferrer() external whenNotPaused nonReentrant {
        if (!started) revert Airdrop__NotStarted();
        if (tokensToClaimAsReferrer == 0) revert Airdrop__NothingToClaim();
        if (referralInfo[msg.sender] == 0) revert Airdrop__NotEligible();

        uint256 amount = (tokensToClaimAsReferrer * referralInfo[msg.sender]) / totalReferredMints;
        _getTraitToken().transfer(msg.sender, amount);
        referralInfo[msg.sender] = 0;
    }

    function addReferralInfo(address referrer, uint256 mints) external whenNotPaused onlyAirdropAccessor {
        if (started) revert Airdrop__AlreadyStarted();
        referralInfo[referrer] += mints;
        totalReferredMints += mints;
    }

    function setPartnerAddresses(address[] calldata partners) external onlyProtocolMaintainer {
        if (partners.length == 0) revert Airdrop__PartnerAddressesNotSet();
        for (uint256 i = 0; i < partners.length; i++) {
            if (partners[i] == address(0)) revert Airdrop__AddressZero();
        }
        partnerAddresses = partners;
    }

    function setLiquidityPoolAddress(address addr) external onlyProtocolMaintainer {
        if (addr == address(0)) revert Airdrop__AddressZero();
        liquidityPoolAddress = addr;
    }

    function setDevAddress(address addr) external onlyProtocolMaintainer {
        if (addr == address(0)) revert Airdrop__AddressZero();
        devAddress = addr;
    }

    function pause() public onlyProtocolMaintainer {
        _pause();
    }

    function unpause() public onlyProtocolMaintainer {
        _unpause();
    }

    //////////////////////////// read functions ////////////////////////////
    function airdropStarted() external view returns (bool) {
        return started;
    }

    function daoFundAllowed() external view returns (bool) {
        return daoAllowed;
    }

    /**
     * internal & private *******************************************
     */
    function _distributeTokens(uint256 totalSupply) internal returns (uint256 tokenTransfered) {
        if (partnerAddresses.length == 0) revert Airdrop__PartnerAddressesNotSet();
        uint256 liquidityPoolShare = (totalSupply * liquidityPoolRate) / BPS;
        uint256 devShare = (totalSupply * devRate) / BPS;
        uint256 playersShare = (totalSupply * playersRate) / BPS;
        uint256 referralShare = (totalSupply * referralRate) / BPS;
        uint256 partnersShare =
            (totalSupply - liquidityPoolShare - devShare - playersShare - referralShare) / partnerAddresses.length;

        // Distribute to liquidity pool and dev address
        IERC20 trait = _getTraitToken();
        trait.transfer(liquidityPoolAddress, liquidityPoolShare);
        trait.transfer(devAddress, devShare);
        tokenTransfered += liquidityPoolShare + devShare;

        // Store the amount allocated to players
        tokensToClaim = playersShare;
        tokensToClaimAsReferrer = referralShare;

        // Distribute to partners
        for (uint256 i = 0; i < partnerAddresses.length; i++) {
            trait.transfer(partnerAddresses[i], partnersShare);
            tokenTransfered += partnersShare;
        }

        return tokenTransfered;
    }

    function _getTraitToken() private view returns (IERC20) {
        return IERC20(_addressProvider.getTrait());
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/security/Pausable.sol';
import './IAirdrop.sol';

contract Airdrop is IAirdrop, Ownable, ReentrancyGuard, Pausable {
    bool private started;
    bool private daoAllowed;

    IERC20 public traitToken;
    uint256 public totalTokenAmount;
    uint256 public totalValue;
    uint256 public totalReferredMints;
    uint256 public tokensToClaim;
    uint256 public tokensToClaimAsReferrer;

    address public liquidityPoolAddress;
    address public devAddress;
    address[] public partnerAddresses;
    address[] public referralAddresses;

    uint256 public liquidityPoolPercent = 10;
    uint256 public devPercent = 15;
    uint256 public referralPercent = 15;
    uint256 public playersPercent = 55;

    mapping(address => uint256) public userInfo;
    mapping(address => uint256) public referralInfo;
    uint256 public totalReferrals;

    address private allowedCaller;

    constructor(address _traitForgeNft) {
        allowedCaller = _traitForgeNft;
    }

    // Modifier to restrict certain functions to the allowed caller
    modifier onlyAllowedCaller() {
      require(msg.sender == allowedCaller, 'Caller is not allowed');
      _;
    }

  function setTraitToken(address _traitToken) external onlyOwner {
    traitToken = IERC20(_traitToken);
  }

  function addReferralInfo(address referrer, uint256 mints) external onlyOwner {
   require(!started, 'Already started');
    referralInfo[referrer] += mints;
    totalReferredMints += mints;
  }

  // Function to update the allowed caller, restricted to the owner of the contract
  function setAllowedCaller(address _allowedCaller) external onlyOwner {
    allowedCaller = _allowedCaller;
  }

  // function to get the current allowed caller
  function getAllowedCaller() external view returns (address) {
    return allowedCaller;
  }

  function startAirdrop(
    uint256 amount
  ) external whenNotPaused nonReentrant onlyOwner {
    require(!started, 'Already started');
    require(amount > 0, 'Invalid amount');
    require(traitToken.allowance(msg.sender, address(this)) >= amount, "ERC20: insufficient allowance");
    traitToken.transferFrom(msg.sender, address(this), amount);
    started = true;
    totalTokenAmount = amount;
    distributeTokens(amount);
  }

  function airdropStarted() external view returns (bool) {
    return started;
  }

  function allowDaoFund() external onlyOwner {
    require(started, 'Not started');
    require(!daoAllowed, 'Already allowed');
    daoAllowed = true;
  }

  function daoFundAllowed() external view returns (bool) {
    return daoAllowed;
  }

 function distributeTokens(uint256 totalSupply) internal {
        uint256 liquidityPoolShare = (totalSupply * liquidityPoolPercent) / 100;
        uint256 devShare = (totalSupply * devPercent) / 100;
        uint256 playersShare = (totalSupply * playersPercent) / 100;
        uint256 referralShare = (totalSupply * referralPercent) / 100;
        uint256 partnersShare = (totalSupply - liquidityPoolShare - devShare - playersShare - referralShare) / partnerAddresses.length;

        // Distribute to liquidity pool and dev address
        traitToken.transfer(liquidityPoolAddress, liquidityPoolShare);
        traitToken.transfer(devAddress, devShare);

        // Store the amount allocated to players
        tokensToClaim = playersShare;
        tokensToClaimAsReferrer = referralShare;

        // Distribute to partners
        for (uint256 i = 0; i < partnerAddresses.length; i++) {
            traitToken.transfer(partnerAddresses[i], partnersShare);
        }
    }

  function addUserAmount(
    address user,
    uint256 amount
  ) external whenNotPaused nonReentrant onlyAllowedCaller {
    require(!started, 'Already started');
    userInfo[user] += amount;
    totalValue += amount;
  }

  function subUserAmount(
    address user,
    uint256 amount
  ) external whenNotPaused nonReentrant onlyAllowedCaller {
    require(!started, 'Already started');
    require(userInfo[user] >= amount, 'Invalid amount');
    userInfo[user] -= amount;
    totalValue -= amount;
  }

  function claim() external whenNotPaused nonReentrant {
    require(started, 'Not started');
    require(totalValue > 0, 'No tokens to claim');
    require(userInfo[msg.sender] > 0, 'Not eligible');

    uint256 amount = (tokensToClaim * userInfo[msg.sender]) / totalValue;
    traitToken.transfer(msg.sender, amount);
    userInfo[msg.sender] = 0;
  }

  function claimAsReferrer() external whenNotPaused nonReentrant {
    require(started, 'Not started');
    require(tokensToClaimAsReferrer > 0, 'No tokens to claim');
    require(referralInfo[msg.sender] > 0, 'Not eligible');

    uint256 amount = (tokensToClaimAsReferrer * referralInfo[msg.sender]) / totalReferredMints;
    traitToken.transfer(msg.sender, amount);
    referralInfo[msg.sender] = 0;
  }
}

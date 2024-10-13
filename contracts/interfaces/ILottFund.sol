// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ILottFund {
    // Structs
    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists;    // whether a requestId exists
        uint256[] randomWords;
    }

    // Events
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);
    event FundReceived(address indexed sender, uint256 amount);
    event FundBalanceUpdated(uint256 newBalance);
    event PayedOut(uint256 tokenId, uint256 claimAmount);
    event TokensBurnt(uint256[] tokenIds);
    event DevShareDistributed(uint256 amount);

    // External Functions
    function bid(uint256 tokenId) external;
    function migrate(address newAddress) external;
    function canTokenBeBidded(uint256 tokenId) external view returns (bool);
    function getFundBalance() external view returns (uint256);
    function getTokenBidAmounts(uint256 tokenId) external view returns (uint256);
    function getMaxBidPotential(uint256 tokenId) external view returns (uint256);
    function getTokensBidded() external view returns (uint256[] memory);
    function getRequestStatus(uint256 requestId) external view returns (bool fulfilled, uint256[] memory randomWords);
    function setNukeFundAddress(address _nukeFundAddress) external;
    function setTaxCut(uint256 _taxCut) external;
    function setMaxAllowedClaimDivisor(uint256 _divisor) external;
    function setMaxBidsPerAddress(uint256 _limit) external;
    function setAmountToWin(uint256 _amountToWin) external
    function setNukeFactorMaxParam(uint256 _nukeFactorMaxParam) external;
    function setEthCollector(address _ethCollector) external;
    function setNativePayment(bool isTrue) external;
    function setAmountToBeBurnt(uint256 _amountToBeBurnt) external;
    function setPausedBids(bool _pausedBids) external;
    function setMaxBidAmount(uint256 _maxBidAmount) external;
    function pause() external;
    function unpause() external;
    function setRequestConfirmations(uint16 _amount) external;
    function setNumWords(uint32 _amount) external;
    function setKeyHash(bytes32 _keyHash) external;
    function setCallbackGasLimit(uint32 _limit) external;

    // Chainlink VRF Functions
    function requestRandomWords(bool enableNativePayment) external returns (uint256 requestId);
}

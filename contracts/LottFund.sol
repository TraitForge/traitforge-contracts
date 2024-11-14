// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { ILottFund } from "contracts/interfaces/ILottFund.sol";
import { ITraitForgeNft } from "contracts/interfaces/ITraitForgeNft.sol";
import { IAirdrop } from "contracts/interfaces/IAirdrop.sol";
import { AddressProviderResolver } from "contracts/core/AddressProviderResolver.sol";
import { VRFCoordinatorV2Interface } from "@chainlink/contracts/src/v0.8/vrf/interfaces/VRFCoordinatorV2Interface.sol";
import { VRFV2PlusClient } from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import { VRFConsumerBaseV2Plus } from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import { ConfirmedOwner } from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import { NukeFund } from "contracts/NukeFund.sol";

contract LottFund is VRFConsumerBaseV2Plus, ILottFund, AddressProviderResolver, ReentrancyGuard, Pausable {
    // Type declarations

    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        uint256[] randomWords;
    }

    // State variables

    uint256 public s_subscriptionId;

    // request IDs
    uint256[] public requestIds;
    uint256 public lastRequestId;

    uint16 public constant MAX_REQUEST_CONFIRMATIONS = 200;
    uint32 public constant MAX_NUM_WORDS = 500;

    address public ethCollector; // fallback address for devrev
    address public nukeFundAddress;
    uint256 public constant MAX_DENOMINATOR = 100_000;
    uint256 public fund;
    uint256 public constant BPS = 10_000; // denominator of basis points
    uint256 public taxCut = 1500; //15%
    uint256 public maxAllowedClaimDivisor = 2;
    uint256 public nukeFactorMaxParam = MAX_DENOMINATOR / 2;
    uint256 public maxBidAmount = 1500;
    uint256 public quantityToBeBurnt = 5;
    uint256 public quantityToWin = 1;
    uint256 public maxBidPotential = 2;
    uint256 public maxBidsPerAddress = 50;
    uint256 public maxModulusForToken = 2;
    uint256 public bidsAmount;
    uint256 public currentRound;

    mapping(uint256 tokenId => uint256 bids) public tokenBidCount;
    mapping(uint256 => RequestStatus) public s_requests;
    mapping(uint256 => mapping(address => uint256)) public bidCountPerRound;
    mapping(address winner => uint256 claimAmount) public winnerClaimAmount;

    uint256[] public tokenIdsBidded;

    bytes32 public keyHash = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 public callbackGasLimit = 2_500_000;

    uint16 public requestConfirmations = 3; // The default is 3, but you can set this higher.

    uint32 public numWords = 6; // For this example, retrieve 2 random values in one request. // Cannot exceed
    // VRFCoordinatorV2_5.MAX_NUM_WORDS.

    bool public pausedBids = false;
    bool public nativePayment = true;

    // Errors
    error LottFund__TaxCutExceedsLimit();
    error LottFund__TokenOwnerIsAddressZero();
    error LottFund__CallerNotTokenOwner();
    error LottFund__ContractNotApproved();
    error LottFund__TokenNotMature();
    error LottFund__AddressIsZero();
    error LottFund__DivisorIsZero();
    error LottFund__BiddingNotFinished();
    error LottFund__TokenBidAmountDepleted();
    error LottFund__TokenCannotBeBidded();
    error LottFund__AddressHasBiddedTooManyTimes(address caller);
    error LottFund__BiddingIsPaused();

    constructor(
        address addressProvider,
        address _ethCollector,
        address _nukefund,
        uint256 subscriptionId,
        address vrfCoordinator
    )
        AddressProviderResolver(addressProvider)
        VRFConsumerBaseV2Plus(vrfCoordinator)
    {
        if (_ethCollector == address(0)) revert LottFund__AddressIsZero();
        if (_nukefund == address(0)) revert LottFund__AddressIsZero();
        s_subscriptionId = subscriptionId;
        ethCollector = _ethCollector;
        nukeFundAddress = _nukefund;
    }

    // Fallback function to receive ETH and update fund balance
    receive() external payable whenNotPaused {
        // FIXED
        uint256 devShare = (msg.value * taxCut) / BPS; // Calculate developer's share (10%)
        uint256 remainingFund = msg.value - devShare; // Calculate remaining funds to add to the fund

        fund += remainingFund; // Update the fund balance
        IAirdrop airdropContract = _getAirdrop();
        address devAddress = payable(_getDevFundAddress());
        address daoAddress = payable(_getDaoFundAddress());

        if (!airdropContract.airdropStarted()) {
            (bool success,) = devAddress.call{ value: devShare }("");
            require(success, "ETH send failed");
            emit DevShareDistributed(devShare);
        } else if (!airdropContract.daoFundAllowed()) {
            (bool success,) = payable(ethCollector).call{ value: devShare }("");
            require(success, "ETH send failed");
            emit DaoShareDistributed(devShare); // FIXED
        } else {
            (bool success,) = daoAddress.call{ value: devShare }("");
            require(success, "ETH send failed");
            emit DevShareDistributed(devShare);
        }
        emit FundReceived(msg.sender, msg.value); // Log the received funds
        emit FundBalanceUpdated(fund); // Update the fund balance
    }

    function bid(uint256 tokenId) public whenNotPaused nonReentrant {
        if (pausedBids) revert LottFund__BiddingIsPaused();
        if (bidCountPerRound[currentRound][msg.sender] >= maxBidsPerAddress) {
            revert LottFund__AddressHasBiddedTooManyTimes(msg.sender);
        }
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        if (traitForgeNft.ownerOf(tokenId) != msg.sender) revert LottFund__CallerNotTokenOwner();
        if (
            !(
                traitForgeNft.getApproved(tokenId) == address(this)
                    || traitForgeNft.isApprovedForAll(msg.sender, address(this))
            )
        ) revert LottFund__ContractNotApproved();
        if (!canTokenBeBidded(tokenId)) revert LottFund__TokenCannotBeBidded();
        bidCountPerRound[currentRound][msg.sender]++;
        bidsAmount++; // increase total bid amounts as max is currently 1500 (can be altered)
        tokenIdsBidded.push(tokenId); // store the array of tokenIds that have been bidded
        tokenBidCount[tokenId]++;
        if (bidsAmount >= maxBidAmount) {
            //if bidsAmount reaches 1500 (currently) then pause bidding and roll the lottery
            pauseBiddingBriefly();
            // We should request random words here
            requestRandomWords(nativePayment);
        }
    }

    function batchBid(uint256[] memory tokenIds) public whenNotPaused nonReentrant {
        if (tokenIds.length == 0) {
            revert("No tokens available"); // FIXED
        }
        if (pausedBids) revert LottFund__BiddingIsPaused();
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        address sender = msg.sender;

        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];

            if (bidCountPerRound[currentRound][sender] >= maxBidsPerAddress) {
                revert LottFund__AddressHasBiddedTooManyTimes(sender);
            }
            if (traitForgeNft.ownerOf(tokenId) != sender) {
                revert LottFund__CallerNotTokenOwner();
            }
            if (
                !(
                    traitForgeNft.getApproved(tokenId) == address(this)
                        || traitForgeNft.isApprovedForAll(sender, address(this))
                )
            ) {
                revert LottFund__ContractNotApproved();
            }
            if (!canTokenBeBidded(tokenId)) revert LottFund__TokenCannotBeBidded();
            bidCountPerRound[currentRound][sender]++;
            bidsAmount++;
            tokenIdsBidded.push(tokenId);
            tokenBidCount[tokenId]++;

            if (bidsAmount >= maxBidAmount) {
                // FIXED
                pauseBiddingBriefly();
                // We should request random words here
                requestRandomWords(nativePayment);
                // MITIGATE #7
                break;
            }
        }
    }

    // MITIGATE #7 #10: Add a function to claim the winning rewards
    function claimWinningRewards() public nonReentrant {
        address payable sender = payable(msg.sender);
        uint256 claimAmount = winnerClaimAmount[sender];
        require(claimAmount > 0, "No claim amount available");
        winnerClaimAmount[sender] = 0;
        (bool success,) = sender.call{ value: claimAmount }("");
        require(success, "Failed to send Ether");
        emit ClaimedOut(sender, claimAmount);
    }

    // MITIGATE #6: add whenNotPaused modifier
    function migrate(address newAddress) external whenNotPaused onlyProtocolMaintainer {
        // require(pausedBids, "bidding is not paused"); // MITIGATE #6
        require(newAddress != address(0), "Invalid new contract address");
        uint256 contractBalance = address(this).balance;
        if (contractBalance > 0) {
            (bool success,) = newAddress.call{ value: contractBalance }("");
            require(success, "Failed to transfer ETH");
        }
    }

    function canTokenBeBidded(uint256 tokenId) public view returns (bool) {
        // MITIGATE #5
        uint256 tokensMaxBidPotential = getMaxBidPotential(tokenId); // calculation for maxBidPotenital from entropy eg
        if (tokensMaxBidPotential == 0) {
            // if tokens maxBidePotential is 0 revert
            return false;
        }
        if (tokensMaxBidPotential <= tokenBidCount[tokenId]) {
            // if tokens maxBidPotential is less than or equal to how many times it has bidded before then revert
            return false; // eg if the tokens maxBidPotential is 2 and it has bidded twice
                // then it cannot bid again
        }
        return true;
    }

    function getRequestStatus(uint256 _requestId)
        external
        view
        returns (bool fulfilled, uint256[] memory randomWords)
    {
        require(s_requests[_requestId].exists, "request not found");
        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }

    function setRequestConfirmations(uint16 _amount) external onlyProtocolMaintainer {
        requestConfirmations = _amount;
    }

    function setKeyHash(bytes32 _keyHash) external onlyProtocolMaintainer {
        keyHash = _keyHash;
    }

    function setCallbackGasLimit(uint32 _limit) external onlyProtocolMaintainer {
        // MITIGATE #9: Add a check to ensure the gas limit does not exceed the maximum limit
        require(_limit <= 2_500_000, "Gas limit exceeds maximum limit.");
        callbackGasLimit = _limit;
    }

    function setNukeFundAddress(address _nukeFundAddress) external onlyProtocolMaintainer {
        nukeFundAddress = _nukeFundAddress;
    }

    function setTaxCut(uint256 _taxCut) external onlyProtocolMaintainer {
        require(_taxCut <= BPS, "Tax cut exceeds maximum limit.");
        taxCut = _taxCut;
    }

    function setMaxAllowedClaimDivisor(uint256 _divisor) external onlyProtocolMaintainer {
        require(_divisor > 0, "Divisor must be greater than 0.");
        maxAllowedClaimDivisor = _divisor;
    }

    function setMaxModulusForToken(uint256 _number) external onlyProtocolMaintainer {
        require(_number != 0, "cannot be 0"); // FIXED
        maxModulusForToken = _number;
    }

    function setNukeFactorMaxParam(uint256 _nukeFactorMaxParam) external onlyProtocolMaintainer {
        require(_nukeFactorMaxParam <= MAX_DENOMINATOR, "Invalid nuke factor parameter.");
        nukeFactorMaxParam = _nukeFactorMaxParam;
    }

    function setEthCollector(address _ethCollector) external onlyProtocolMaintainer {
        ethCollector = _ethCollector;
    }

    function setMaxBidsPerAddress(uint256 _limit) external onlyProtocolMaintainer {
        maxBidsPerAddress = _limit;
    }

    function setNativePayment(bool isTrue) external onlyProtocolMaintainer {
        require(isTrue != nativePayment);
        nativePayment = isTrue;
    }

    // MITIGATE #3: Add a function to set the number of words and the amount to be burnt
    function setNumWordsAndAmountToBeBurnt(
        uint32 _numWords,
        uint256 _quantityToBeBurnt
    )
        external
        onlyProtocolMaintainer
    {
        require(_numWords >= _quantityToBeBurnt + 1, "numWords must be greater or equal than quantityToBeBurnt + 1");
        quantityToBeBurnt = _quantityToBeBurnt;
        numWords = _numWords;
    }

    function setAmountToWin(uint256 _amountToWin) external onlyProtocolMaintainer {
        quantityToWin = _amountToWin;
    }

    function setPausedBids(bool _pausedBids) external onlyProtocolMaintainer {
        pausedBids = _pausedBids;
    }

    function setMaxBidAmount(uint256 _maxBidAmount) external onlyProtocolMaintainer {
        maxBidAmount = _maxBidAmount;
    }

    function setSubscriptionId(uint256 _subscriptionId) external onlyProtocolMaintainer {
        s_subscriptionId = _subscriptionId;
    }

    function pause() public onlyProtocolMaintainer {
        _pause();
    }

    function unpause() public onlyProtocolMaintainer {
        _unpause();
    }

    function getFundBalance() public view returns (uint256) {
        return fund;
    }

    function getTokenBidAmounts(uint256 tokenId) public view returns (uint256) {
        return tokenBidCount[tokenId];
    }

    function getMaxBidPotential(uint256 tokenId) public view returns (uint256) {
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        uint256 entropy = traitForgeNft.getTokenEntropy(tokenId);
        uint256 tokenMaxBidPotential = entropy % maxModulusForToken;

        // MITIGATE #4: If the entropy is 999999, return tokenMaxBidPotential + 1
        return entropy == 999_999 ? tokenMaxBidPotential + 1 : tokenMaxBidPotential;
    }

    function getTokensBidded() public view returns (uint256[] memory) {
        return tokenIdsBidded;
    }

    // INTERNAL FUNCTIONS

    function requestRandomWords(bool enableNativePayment) internal returns (uint256 requestId) {
        // Will revert if subscription is not set and funded.
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({ nativePayment: enableNativePayment }))
            })
        );
        s_requests[requestId] = RequestStatus({ randomWords: new uint256[](0), exists: true, fulfilled: false });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] calldata _randomWords) internal override {
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords);
        bidPayout(_randomWords);
    }

    function pauseBiddingBriefly() internal whenNotPaused {
        pausedBids = true;
    }

    function bidPayout(uint256[] calldata _randomWords) internal whenNotPaused nonReentrant {
        // if (bidsAmount != maxBidAmount) {
        //     //if bidsAmount has no maxxed out then revert
        //     revert LottFund__BiddingNotFinished();
        // }

        for (uint256 i = 1; i <= quantityToWin; i++) {
            // A for loop incase we want to add multiple winners later
            uint256 winnerIndex = _randomWords[0] % tokenIdsBidded.length; // get the index of the array of tokenIds
                // that have been bidded
            uint256 winnerTokenId = tokenIdsBidded[winnerIndex]; // Get the winner's token ID
            uint256 finalNukeFactor = NukeFund(payable(nukeFundAddress)).calculateNukeFactor(winnerTokenId); // finalNukeFactor
                // has 5
                // digits
            uint256 potentialClaimAmount = (fund * finalNukeFactor) / MAX_DENOMINATOR; // Calculate the potential claim
            // amount based on the finalNukeFactor
            uint256 maxAllowedClaimAmount = fund / maxAllowedClaimDivisor; // Define a maximum allowed claim amount as
                // 50%
            // of the current fund size

            // Directly assign the value to claimAmount based on the condition, removing the redeclaration
            uint256 claimAmount = finalNukeFactor > nukeFactorMaxParam ? maxAllowedClaimAmount : potentialClaimAmount;

            fund -= claimAmount; // Deduct the claim amount from the fund
            ITraitForgeNft traitForgeNft = _getTraitForgeNft();
            address payable ownerOfWinningToken = payable(traitForgeNft.ownerOf(winnerTokenId));
            winnerClaimAmount[ownerOfWinningToken] += claimAmount; // Store the claim amount for the winner
            // (bool success,) = payable(ownerOfWinningToken).call{ value: claimAmount }("");
            // require(success, "Failed to send Ether");
            emit BidWinner(ownerOfWinningToken, winnerTokenId, claimAmount); // Emit the event with the actual claim
                // amount

            // MITIGATE #2: Remove the winner's token ID from the array of tokenIds bidded
            // remove the winner's token ID from the array of tokenIds bidded
            // replace winnerTokenId with the last element in the array and then remove the last element
            tokenIdsBidded[winnerIndex] = tokenIdsBidded[tokenIdsBidded.length - 1];
            tokenIdsBidded.pop();
        }

        uint256[] memory tokensToBurn = new uint256[](quantityToBeBurnt); //memory to stre the tokens to be burnt
        for (uint256 i = 1; i <= quantityToBeBurnt; i++) {
            // Use the next 5 numbers to locate the indexes of 5 tokenIds to burn
            uint256 burnIndex = _randomWords[i] % tokenIdsBidded.length; // Find the burn index
            tokensToBurn[i - 1] = tokenIdsBidded[burnIndex]; // Store the token ID to burn
        }
        burnTokens(tokensToBurn); // Burn the selected tokenIds
        resetRound();

        emit FundBalanceUpdated(fund); // Update the fund balance
        emit TokensBurnt(tokensToBurn);
    }

    function burnTokens(uint256[] memory tokenIds) internal whenNotPaused {
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        for (uint256 i = 0; i < tokenIds.length; i++) {
            // MITIGATE #2: Check if the token ID is owned by an address before burning in case we have same token ID
            if (traitForgeNft.ownerOf(tokenIds[i]) != address(0)) {
                traitForgeNft.burn(tokenIds[i]); // Burn each token
            }
        }
    }

    function resetRound() internal whenNotPaused {
        bidsAmount = 0; //reset count of bids
        delete tokenIdsBidded; // reset array of tokens bidded
        pausedBids = false; // set bidding back to active
        currentRound++; // increase round to reset the mapping(uint256 => mapping(address => uint256)) public
            // bidCountPerRound;
    }

    function _getDevFundAddress() private view returns (address) {
        return _addressProvider.getDevFund();
    }

    function _getDaoFundAddress() private view returns (address) {
        return _addressProvider.getDAOFund();
    }

    function _getTraitForgeNft() private view returns (ITraitForgeNft) {
        return ITraitForgeNft(_addressProvider.getTraitForgeNft());
    }

    function _getAirdrop() private view returns (IAirdrop) {
        return IAirdrop(_addressProvider.getAirdrop());
    }
}

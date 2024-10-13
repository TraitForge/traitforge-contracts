// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { ILottFund } from "contracts/interfaces/INukeFund.sol";
import { ITraitForgeNft } from "contracts/interfaces/ITraitForgeNft.sol";
import { IAirdrop } from "contracts/interfaces/IAirdrop.sol";
import { AddressProviderResolver } from "contracts/core/AddressProviderResolver.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts@1.2.0/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts@1.2.0/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract LottFund is VRFConsumerBaseV2Plus, ILottFund, AddressProviderResolver, ReentrancyGuard, Pausable {
    // Structs
    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        uint256[] randomWords;
    }

    // subscription ID.
    uint256 public s_subscriptionId;

    // request IDs
    uint256[] public requestIds;
    uint256 public lastRequestId;

    // State variables
    address public nukeFundAddress;
    uint256 public constant MAX_DENOMINATOR = 100_000;
    uint256 private fund;
    uint256 private constant BPS = 10_000; // denominator of basis points
    uint256 public taxCut = 1500; //15%
    uint256 public maxAllowedClaimDivisor = 2;
    uint256 public nukeFactorMaxParam = MAX_DENOMINATOR / 2;
    address public ethCollector; // fallback address for devrev
    bool public pausedBids = false;
    uint256 public maxBidAmount = 1500;
    uint256 public amountToBeBurnt = 5;
    uint256 public amountToWin = 1;
    uint256 public maxBidsPerAddress = 150
    uint256 public maxModulusForToken = 2;
    uint256 public bidsAmount;
    bool private nativePayment = true;
    mapping(uint256 tokenId => uint256 bids) public tokenBidCount;
    mapping(uint256 => RequestStatus) public s_requests; 
    uint256 public currentRound; 
    mapping(uint256 => mapping(address => uint256)) public bidCountPerRound;

    uint256[] public tokenIdsBidded;

    bytes32 public keyHash = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 public callbackGasLimit = 100000;

    uint16 public requestConfirmations = 3; // The default is 3, but you can set this higher.

    uint32 public numWords = 6; // For this example, retrieve 2 random values in one request. // Cannot exceed VRFCoordinatorV2_5.MAX_NUM_WORDS.

    // Events
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

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
    error LottFund__TokenHasNoBidPotential();

    // Modifiers

    // Functions

    // Constructor 
    constructor(address addressProvider, address _ethCollector, address _nukefund, uint256 subscriptionId) AddressProviderResolver(addressProvider) VRFConsumerBaseV2Plus(0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B) {
        if (_ethCollector == address(0)) revert LottFund__AddressIsZero();
        s_subscriptionId = subscriptionId;
        ethCollector = _ethCollector;
        nukeFundAddress = _nukefund;
    }

    // Fallback function to receive ETH and update fund balance
    receive() external payable {
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
        } else {
            (bool success,) = daoAddress.call{ value: devShare }("");
            require(success, "ETH send failed");
            emit DevShareDistributed(devShare);
        }
        emit FundReceived(msg.sender, msg.value); // Log the received funds
        emit FundBalanceUpdated(fund); // Update the fund balance
    }




    // EXTERNAL FUNCTIONS

    function bid(uint256 tokenId) public whenNotPaused nonReentrant {
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        if (traitForgeNft.ownerOf(tokenId) != msg.sender) revert LottFund__CallerNotTokenOwner();
        if (
            !(
                traitForgeNft.getApproved(tokenId) == address(this)
                    || traitForgeNft.isApprovedForAll(msg.sender, address(this))
            )
        ) revert NukeFund__ContractNotApproved();
        canTokenBeBidded(tokenId); //requires
        bidCountPerRound[currentRound][msg.sender]++;
        bidsAmount++; // increase total bid amounts as max is currently 1500 (can be altered)
        tokenIdsBidded.push(tokenId); // store the array of tokenIds that have been bidded
        tokenBidCount[tokenId]++;
        if(bidsAmount >= maxBidAmount) { //if bidsAmount reaches 1500 (currently) then pause bidding and roll the lottery
            pauseBiddingBriefly();
            BidPayout();
        }
    }

    function migrate(address newAddress) external whenNotPaused onlyProtocolMaintainer {
        require(newAddress != address(0), "Invalid new contract address");
        uint256 contractBalance = address(this).balance;
        if (contractBalance > 0) {
            (bool success, ) = newAddress.call{value: contractBalance}("");
            require(success, "Failed to transfer ETH");
        }
    }





    // INTERNAL FUNCTIONS

    function pauseBiddingBriefly() internal whenNotPaused {
       pausedBids = true; 
    }

    function BidPayout(uint256[] calldata _randomWords) internal whenNotPaused nonReentrant {
        if (bidsAmount != maxBidAmount){ //if bidsAmount has no maxxed out then revert
            revert LottFund__BiddingNotFinished();
        }  
        requestRandomWords(nativePayment);
        uint256[] memory tokensToWin = new uint256[](amountToWin); //memory to stre the tokens to be burnt
        for (uint256 i = 1; i <= amountToWin; i++) { // A for loop incase we want to add multiple winners later
            uint256 winnerIndex = _randomWords[0] % tokenIdsBidded.length; // get the index of the array of tokenIds that have been bidded
            uint256 winnerTokenId = tokenIdsBidded[winnerIndex]; // Get the winner's token ID
        }

        uint256[] memory tokensToBurn = new uint256[](amountToBeBurnt); //memory to stre the tokens to be burnt
        for (uint256 i = 1; i <= amountToBeBurnt; i++) { // Use the next 5 numbers to locate the indexes of 5 tokenIds to burn
            uint256 burnIndex = _randomWords[i] % tokenIdsBidded.length; // Find the burn index
            tokensToBurn[i - 1] = tokenIdsBidded[burnIndex]; // Store the token ID to burn
        }
        burnTokens(tokensToBurn);  // Burn the selected tokenIds
        
        uint256 finalNukeFactor = nukeFundAddress.calculateNukeFactor(winnerTokenId); // finalNukeFactor has 5 digits
        uint256 potentialClaimAmount = (fund * finalNukeFactor) / MAX_DENOMINATOR; // Calculate the potential claim
            // amount based on the finalNukeFactor
        uint256 maxAllowedClaimAmount = fund / maxAllowedClaimDivisor; // Define a maximum allowed claim amount as 50%
            // of the current fund size

        // Directly assign the value to claimAmount based on the condition, removing the redeclaration
        uint256 claimAmount = finalNukeFactor > nukeFactorMaxParam ? maxAllowedClaimAmount : potentialClaimAmount;

        fund -= claimAmount; // Deduct the claim amount from the fund
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        address payable ownerOfWinningToken = payable(traitForgeNft.ownerOf(winnerTokenId));

        (bool success,) = payable(ownerOfWinningToken).call{ value: claimAmount }("");
        require(success, "Failed to send Ether");
        resetRound();

        emit PayedOut(winnerTokenId, claimAmount); // Emit the event with the actual claim amount
        emit FundBalanceUpdated(fund); // Update the fund balance
        emit TokensBurnt(tokensToBurn);
    }

    function burnTokens(uint256[] memory tokenIds) internal whenNotPaused {
      ITraitForgeNft traitForgeNft = _getTraitForgeNft();
      for (uint256 i = 0; i < tokenIds.length; i++) {
          traitForgeNft.burn(tokenIds[i]); // Burn each token
      }
    }

    function resetRound() internal whenNotPaused {
        bidsAmount = 0; //reset count of bids
        delete tokenIdsBidded; // reset array of tokens bidded
        pausedBids = false; // set bidding back to active
        currentRound++; // increase round to reset the mapping(uint256 => mapping(address => uint256)) public bidCountPerRound;
    }





    // VIEW FUNCTIONS

    function canTokenBeBidded(uint256 tokenId) external view returns (bool){
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        entropy = traitForgeNft.getTokenEntropy(tokenId); // get entities 6 digit entropy
        maxBidPotential = entropy % maxModulusForToken; // calculation for maxBidPotenital from entropy eg 999999 = 
        if(entropy == 999_999){ // if golden god (999999) maxBidPotential is +1 over max
            maxBidPotential = 3
        }
        bidAmountForToken = tokenBidCount[tokenId]; //how many times has the token bidded before?
        if(maxBidPotential == 0){ // if tokens maxBidePotential is 0 revert
            revert LottFund__TokenHasNoBidPotential();
        }
        if(maxBidPotential <= bidAmountForToken){ // if tokens maxBidPotential is less than or equal to how many times it has bidded before then revert
            revert LottFund__TokenBidAmountDepleted(); // eg if the tokens maxBidPotential is 2 and it has bidded twice then it cannot bid again
        }
        return true; 
    }

    
    // GETTER FUNCTIONS

    function getFundBalance() public view returns (uint256) {
        return fund;
    }

    function getTokenBidAmounts(tokenId) public view returns (uint256) {
        return tokenBidCount[tokenId];
    }

    function getMaxBidPotential(tokenId) public view returns (uint256) {
        ITraitForgeNft traitForgeNft = _getTraitForgeNft();
        entropy = traitForgeNft.getTokenEntropy(tokenId);
        maxBidPotential = entropy % maxModulusForToken;
        return maxBidPotential;
    }

    function getTokensBidded() public view returns (uint256[] memory) {
       return tokenIdsBidded;
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



    // SETTER FUNCTIONS

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

    function setMaxModulusForToken(uint256 _number) external onlyProtocolMaintainer{
        maxModulusForToken = _number
    }

    function setNukeFactorMaxParam(uint256 _nukeFactorMaxParam) external onlyProtocolMaintainer {
        require(_nukeFactorMaxParam <= MAX_DENOMINATOR, "Invalid nuke factor parameter.");
        nukeFactorMaxParam = _nukeFactorMaxParam;
    }

    function setEthCollector(address _ethCollector) external onlyProtocolMaintainer {
        ethCollector = _ethCollector;
    }

    function setMaxBidsPerAddress(uint256 _limit) external onlyProtocolMaintainer{
        maxBidsPerAddress = _limit;
    }

    function setNativePayment(bool isTrue) external onlyProtocolMaintainer {
        require(isTrue != nativePayment);
        nativePayment = isTrue;
    }

    function setAmountToBeBurnt(uint256 _amountToBeBurnt) external onlyProtocolMaintainer {
       amountToBeBurnt = _amountToBeBurnt;
    }

    function setAmountToWin(uint256 _amountToWin) external onlyProtocolMaintainer {
        amountToWin = _amountToWin;
    }

    function setPausedBids(bool _pausedBids) external onlyProtocolMaintainer {
        pausedBids = _pausedBids;
    }

    function setMaxBidAmount(uint256 _maxBidAmount) external onlyProtocolMaintainer {
        maxBidAmount = _maxBidAmount;
    }

    function pause() public onlyProtocolMaintainer {
        _pause();
    }

    function unpause() public onlyProtocolMaintainer {
        _unpause();
    }

    

    // CHAINLINK VRF FUNCTIONS

    function requestRandomWords(                                   // unsure about the difference of this and fulfillRandomWords
        bool enableNativePayment
    ) internal returns (uint256 requestId) {
        // Will revert if subscription is not set and funded.
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: enableNativePayment
                    })
                )
            })
        );
        s_requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] calldata _randomWords
    ) internal override {
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true; 
        s_requests[_requestId].randomWords = _randomWords; 
        emit RequestFulfilled(_requestId, _randomWords);        
    }

    function getRequestStatus(
        uint256 _requestId
    ) external view returns (bool fulfilled, uint256[] memory randomWords) {
        require(s_requests[_requestId].exists, "request not found");
        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }

    function setRequestConfirmations(uint16 _amount) external onlyProtocolMaintainer {
        requestConfirmations = _amount;
    }

    function setNumWords(uint32 _amount) external onlyProtocolMaintainer {
        numWords = _amount;
    }

    function setKeyHash(bytes32 _keyHash) external onlyProtocolMaintainer {
        keyHash = _keyHash;
    }

    function setCallbackGasLimit(uint32 _limit) external onlyProtocolMaintainer {
        callbackGasLimit = _limit;
    }
}

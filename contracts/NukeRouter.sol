// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FundRouter {

    // routing addresses
    address public nukeFund;
    address public lottFund;

    // state variables
    uint256 public NUKEFUND_PERCENT = 1000; // 10% to NukeFund
    uint256 public LOTT_FUND_PERCENT = 9000; // 90% to LottFund
    uint256 public constant BPS = 10_000; // 100% for dividing

    // constructor
    constructor(address _nukeFund, address _lottFund) {
        require(_nukeFund != address(0), "NukeFund address cannot be zero");
        require(_lottFund != address(0), "LottFund address cannot be zero");

        nukeFund = _nukeFund;
        lottFund = _lottFund;
    }
    

    // RECEIVE
    receive() external payable {  // Receive ETH and route the funds
        uint256 totalAmount = msg.value;
        uint256 nukeFundAmount = (totalAmount * NUKEFUND_PERCENT) / BPS;
        uint256 lottFundAmount = (totalAmount * LOTT_FUND_PERCENT) / BPS;

        (bool successNuke,) = payable(nukeFund).call{value: nukeFundAmount}(""); // Transfer 10% to NukeFund
        require(successNuke, "Failed to send funds to NukeFund");

        (bool successLott,) = payable(lottFund).call{value: lottFundAmount}(""); // Transfer 90% to LottFund
        require(successLott, "Failed to send funds to LottFund");
    }
    



    // SETTER FUNCTIONS

    function setNukeFund(address _nukeFund) external onlyProtocolMaintainer {
        require(_nukeFund != address(0), "NukeFund address cannot be zero");
        nukeFund = _nukeFund;
    }

    function setLottFund(address _lottFund) external onlyProtocolMaintainer {  
        require(_lottFund != address(0), "LottFund address cannot be zero");
        lottFund = _lottFund;
    }

    function setLottSendAmount(uint256 _amount) external onlyProtocolMaintainer {  
      require(_amount != 0, "Amount cannot be zero");
      require(_amount + NUKEFUND_PERCENT <= BPS, "Total percentage exceeds 100%");
      LOTT_FUND_PERCENT = _amount;
    }

    function setNukeSendAmount(uint256 _amount) external onlyProtocolMaintainer {  
       require(_amount != 0, "Amount cannot be zero");
       require(_amount + LOTT_FUND_PERCENT <= BPS, "Total percentage exceeds 100%");
       NUKEFUND_PERCENT = _amount;
    }


}

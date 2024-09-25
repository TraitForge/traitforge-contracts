// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { console } from "@forge-std/console.sol";

import { DevFund } from "contracts/DevFund.sol";

contract DeployDevFund is BaseScript {
    function run() public virtual initConfig broadcast {
        if (ethCollector == address(0)) {
            revert AddressIsZero();
        }

        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }
        address newDevFundAddress = _deployDevFund();
        console.log("DevFund deployed at address: ", newDevFundAddress);
    }

    function _deployDevFund() internal returns (address) {
        return address(new DevFund(addressProvider, ethCollector));
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { Roles } from "contracts/libraries/Roles.sol";
import { console } from "@forge-std/console.sol";

import { NukeFund } from "contracts/NukeFund.sol";

contract DeployNukeFund is BaseScript {
    function run() public virtual initConfig broadcast {
        if (ethCollector == address(0)) {
            revert AddressIsZero();
        }

        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }
        address newNukeFundAddress = _deployNukeFund();
        console.log("NukeFund deployed at address: ", newNukeFundAddress);
    }

    function _deployNukeFund() internal returns (address) {
        return address(new NukeFund(addressProvider, ethCollector));
    }
}

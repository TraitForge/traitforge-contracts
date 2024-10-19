// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { Roles } from "contracts/libraries/Roles.sol";
import { console } from "@forge-std/console.sol";

import { NukeRouter } from "contracts/NukeRouter.sol";
import { NukeFund } from "contracts/NukeFund.sol";
import { NukeRouter } from "contracts/NukeRouter.sol";
import { LottFund } from "contracts/LottFund.sol";

contract DeployNukeRouter is BaseScript {
    function run() public virtual initConfig broadcast {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        if (ethCollector == address(0)) {
            revert AddressIsZero();
        }

        address nukeFundAddress = _deployNukeFund();
        console.log("NukeFund deployed at address: ", nukeFundAddress);
    }

    function _deployNukeFund() internal returns (address) {
        return address(new NukeFund(addressProvider, ethCollector));
    }
}

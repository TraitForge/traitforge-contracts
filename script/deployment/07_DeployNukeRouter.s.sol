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

        if (nukeFund == address(0)) {
            revert AddressIsZero();
        }

        if (lottFund == address(0)) {
            revert AddressIsZero();
        }

        address newNukeRouterAddress = _deployFundRouter();
        console.log("NukeRouter deployed at address: ", newNukeRouterAddress);
    }

    function _deployFundRouter() internal returns (address) {
        return address(new NukeRouter(addressProvider, nukeFund, lottFund));
    }
}

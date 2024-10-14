// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { Roles } from "contracts/libraries/Roles.sol";
import { console } from "@forge-std/console.sol";

import { FundRouter } from "contracts/NukeRouter.sol";

contract DeployNukeRouter is BaseScript {
    function run() public virtual initConfig broadcast {
        address newNukeRouterAddress = _deployFundRouter();
        console.log("NukeRouter deployed at address: ", newNukeRouterAddress);
    }

    function _deployFundRouter() internal returns (address) {
        return address(new FundRouter(nukeFund, lottFund));
    }
}

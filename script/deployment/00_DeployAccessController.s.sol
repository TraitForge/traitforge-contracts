// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AccessController } from "contracts/core/AccessController.sol";
import { console } from "@forge-std/console.sol";

contract DeployAccessController is BaseScript {

    function run() public virtual initConfig broadcast {
        if (defaultAdmin == address(0) || protocolMaintainer == address(0)) {
            revert AddressIsZero();
        }

        address newAccessController = _deployAccessController();
        console.log("AccessController deployed at address: ", newAccessController);
    }

    function _deployAccessController() internal returns (address) {
        return address(new AccessController(defaultAdmin, protocolMaintainer));
    }
}

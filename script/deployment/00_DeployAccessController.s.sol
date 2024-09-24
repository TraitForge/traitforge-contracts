// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AccessController } from "contracts/core/AccessController.sol";

contract DeployAccessController is BaseScript {
    function run() public virtual initConfig broadcast {
        _deployAccessController();

        if (defaultAdmin == address(0) || protocolMaintainer == address(0)) {
            revert AddressIsZero();
        }
    }

    function _deployAccessController() internal returns (AccessController) {
        AccessController ac = new AccessController(defaultAdmin, protocolMaintainer);
        return ac;
    }
}

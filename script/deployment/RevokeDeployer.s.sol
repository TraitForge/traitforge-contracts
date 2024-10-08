// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";
import { Roles } from "contracts/libraries/Roles.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { console } from "@forge-std/console.sol";

contract RevokeDeployer is BaseScript {
    function run() public virtual initConfig broadcast {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        AddressProvider ap = AddressProvider(addressProvider);
        AccessControl ac = AccessControl(address(ap.getAccessController()));

        ////////////////////  Revoking Deployer  ////////////////////
        // !!!! HERE WE ARE REVOKING THE DEPLOYER DEFAULT ADMIN AND PROTOCOL MAINTAINER FROM THE DEPLOYER ADDRESS !!!!
        bytes32 adminRole = ac.DEFAULT_ADMIN_ROLE();

        if (ac.hasRole(Roles.PROTOCOL_MAINTAINER, address(broadcaster))) {
            ac.renounceRole(Roles.PROTOCOL_MAINTAINER, address(broadcaster));
            console.log("Protocol Maintainer role renounced from: ", broadcaster);
        } else {
            console.log("Protocol Maintainer role not found for: ", broadcaster);
        }

        if (ac.hasRole(adminRole, address(broadcaster))) {
            ac.renounceRole(adminRole, address(broadcaster));
            console.log("Default Admin role renounced from: ", broadcaster);
        } else {
            console.log("Default Admin role not found for: ", broadcaster);
        }
    }
}

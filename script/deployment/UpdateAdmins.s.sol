// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";
import { Roles } from "contracts/libraries/Roles.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { console } from "@forge-std/console.sol";

contract UpdateAdmins is BaseScript {
    function run() public virtual initConfig broadcast {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        AddressProvider ap = AddressProvider(addressProvider);
        AccessControl ac = AccessControl(address(ap.getAccessController()));

        ////////////////////  Grant Roles  ////////////////////
        // HERE WE ARE GRANTING THE DEFAULT ADMIN ROLE TO THE DEFAULT ADMIN ADDRESS SET IN THE CONFIGURATION
        // AND THE PROTOCOL MAINTAINER ROLE TO THE PROTOCOL MAINTAINER ADDRESS SET IN THE CONFIGURATION
        bytes32 adminRole = ac.DEFAULT_ADMIN_ROLE();
        if (!ac.hasRole(adminRole, address(defaultAdmin))) {
            ac.grantRole(adminRole, address(defaultAdmin));
            console.log("Default Admin role granted to: ", defaultAdmin);
        }
        if (!ac.hasRole(Roles.PROTOCOL_MAINTAINER, address(protocolMaintainer))) {
            ac.grantRole(Roles.PROTOCOL_MAINTAINER, address(protocolMaintainer));
            console.log("Protocol Maintainer role granted to: ", protocolMaintainer);
        }
    }
}

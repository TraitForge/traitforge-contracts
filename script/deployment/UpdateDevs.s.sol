// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";
import { Roles } from "contracts/libraries/Roles.sol";
import { DevFund } from "contracts/DevFund.sol";
import { console } from "@forge-std/console.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";

/// @title UpdateDevs
contract UpdateDevs is BaseScript {
    struct Dev {
        address user;
        uint256 weight;
    }

    function run() public virtual initConfig broadcast {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        AddressProvider ap = AddressProvider(addressProvider);
        AccessControl ac = AccessControl(address(ap.getAccessController()));

        // HERE WE ARE GRANTING THE DEPLOYER ITSELF WITH DEV_FUND_ACCESSOR ROLE
        // IMPORTANT (BROADCASTER) DEPLOYER SHOULD HAVE THE DEFAULT_ADMIN_ROLE

        if (!ac.hasRole(Roles.DEV_FUND_ACCESSOR, address(broadcaster))) {
            ac.grantRole(Roles.DEV_FUND_ACCESSOR, address(broadcaster));
            console.log("DEV_FUND_ACCESSOR role granted to: ", broadcaster);
        }

        DevFund df = DevFund(payable(address(ap.getDevFund())));
        Dev[] memory devs = new Dev[](3);
        devs[0] = Dev({ user: address(0x225b791581185B73Eb52156942369843E8B0Eec7), weight: 3266 });
        devs[1] = Dev({ user: address(0xb00E81207bcDA63c9E290E0b748252418818c869), weight: 3266 });
        devs[2] = Dev({ user: address(0x3052d9bb0cF4A6F8585ad21761444EAF7a55cD71), weight: 200 });

        for (uint256 i = 0; i < devs.length; i++) {
            df.addDev(devs[i].user, devs[i].weight);
            console.log("Dev added: ", devs[i].user, " with weight: ", devs[i].weight);
        }
    }
}

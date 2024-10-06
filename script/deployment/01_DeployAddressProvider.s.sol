// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";
import { console } from "@forge-std/console.sol";

contract DeployAddressProvider is BaseScript {
    function run() public virtual initConfig broadcast {
        if (accessController == address(0)) {
            revert AccessControllerAddressIsZero();
        }
        
        address newAddressProvider = _deployAddressProvider();
        console.log("New AddressProvider deployed at address: ", newAddressProvider);
    }

    function _deployAddressProvider() internal returns (address) {
        return address(new AddressProvider(accessController));
    }
}

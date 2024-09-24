// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";

contract DeployAddressProvider is BaseScript {
    function run() public virtual initConfig broadcast {
        if (accessController == address(0)) {
            revert AccessControllerAddressIsZero();
        }
        
        _deployAddressProvider();
        // console2.log("AccessController deployed at address: ", ap);
    }

    function _deployAddressProvider() internal returns (AddressProvider) {
        return new AddressProvider(accessController);
    }
}

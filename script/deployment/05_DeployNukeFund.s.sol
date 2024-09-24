// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";
import { Roles } from "contracts/libraries/Roles.sol";

import { NukeFund } from "contracts/NukeFund.sol";

contract DeployNukeFund is BaseScript {
    function run() public virtual initConfig broadcast {
        if (nukeFund != address(0)) {
            revert AlreadyDeployed();
        }

        if (ethCollector == address(0)) {
            revert AddressIsZero();
        }

        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }
        address nf = _deployNukeFund();
        AddressProvider ap = AddressProvider(addressProvider);
        ap.setNukeFund(nf);
    }

    function _deployNukeFund() internal returns (address) {
        return address(new NukeFund(addressProvider, ethCollector));
    }
}

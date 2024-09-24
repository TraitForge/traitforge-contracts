// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";

import { EntityForging } from "contracts/EntityForging.sol";

contract DeployEntityForging is BaseScript {
    function run() public virtual initConfig broadcast {
        if (entityForging != address(0)) {
            revert AlreadyDeployed();
        }

        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        AddressProvider ap = AddressProvider(addressProvider);
        EntityForging ef = _deployEntityForging();
        ap.setEntityForging(address(ef));
    }

    function _deployEntityForging() internal returns (EntityForging) {
        return new EntityForging(addressProvider);
    }
}

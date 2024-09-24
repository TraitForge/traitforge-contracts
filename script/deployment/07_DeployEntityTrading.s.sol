// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";

import { EntityTrading } from "contracts/EntityTrading.sol";

contract DeployEntityTrading is BaseScript {
    function run() public virtual initConfig broadcast {
        if (entityTrading != address(0)) {
            revert AlreadyDeployed();
        }

        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        AddressProvider ap = AddressProvider(addressProvider);
        EntityTrading et = _deployEntityTrading();
        ap.setEntityTrading(address(et));
    }

    function _deployEntityTrading() internal returns (EntityTrading) {
        return new EntityTrading(addressProvider);
    }
}

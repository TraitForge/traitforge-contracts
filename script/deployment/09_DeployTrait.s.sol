// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";

import { Trait } from "contracts/Trait.sol";

contract DeployTrait is BaseScript {
    function run() public virtual initConfig broadcast {
        if (trait != address(0)) {
            revert AlreadyDeployed();
        }

        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        AddressProvider ap = AddressProvider(addressProvider);
        address t = _deployTrait();
        ap.setTrait(t);
    }

    function _deployTrait() internal returns (address) {
        return address(new Trait("Trait", "TRAIT", 18, 1_000_000 ether));
    }
}

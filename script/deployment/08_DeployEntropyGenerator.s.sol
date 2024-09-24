// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";

import { EntropyGenerator } from "contracts/EntropyGenerator.sol";

contract DeployEntropyGenerator is BaseScript {
    function run() public virtual initConfig broadcast {
        if (entropyGenerator != address(0)) {
            revert AlreadyDeployed();
        }

        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        AddressProvider ap = AddressProvider(addressProvider);
        EntropyGenerator eg = _deployEntropyGenerator();
        ap.setEntropyGenerator(address(eg));
    }

    function _deployEntropyGenerator() internal returns (EntropyGenerator) {
        return new EntropyGenerator(addressProvider);
    }
}

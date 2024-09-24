// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.23;

import { Script, console } from "@forge-std/Script.sol";

import { Configured, ConfigLib, Config } from "config/Configured.sol";

abstract contract BaseScript is Script, Configured {
    using ConfigLib for Config;

    /// @dev The address of the transaction broadcaster.
    address internal broadcaster;

    error AccessControllerAddressIsZero();
    error AddressProviderAddressIsZero();
    error AlreadyDeployed();
    error AddressIsZero();

    modifier initConfig() {
        _initConfig();
        _loadConfig();
        _;
    }

    modifier broadcast() {
        uint256 deployerKey = vm.envUint("DEPLOYER_KEY");
        vm.startBroadcast(deployerKey);
        broadcaster = vm.addr(deployerKey);
        _;
        vm.stopBroadcast();
    }
}

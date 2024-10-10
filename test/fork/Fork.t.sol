// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import { Test } from "@forge-std/Test.sol";
import { Config, ConfigLib } from "config/ConfigLib.sol";
import { Configured } from "config/Configured.sol";

/// @notice Common logic needed by all fork tests.
abstract contract Fork_Test is Test, Configured {
    using ConfigLib for Config;

    function setUp() public virtual {
        // Fork Polygon Mainnet at a specific block number.
        vm.createSelectFork({ blockNumber: 20_893_818, urlOrAlias: "base" });

        _initConfig();
        _loadConfig();
    }
}

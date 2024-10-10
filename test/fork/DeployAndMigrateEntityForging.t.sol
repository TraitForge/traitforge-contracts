// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import { Fork_Test } from "./Fork.t.sol";
import { FixEntityForging } from "script/deployment/FixEntityForging.s.sol";
import { EntityForging } from "contracts/EntityForging.sol";

contract DeployAndMigrateEntityForging is Fork_Test {
    FixEntityForging fixScript;

    function setUp() public override {
        super.setUp();
        fixScript = new FixEntityForging();
    }

    function test_deployAndMigrateEntityForging() public {
        EntityForging(fixScript.run());
    }
}

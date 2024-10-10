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
        EntityForging newEntityForgingContract = EntityForging(fixScript.run());
        // uint256 index = newEntityForgingContract.listedTokenIds(2165);
        // (address account, uint256 tokenId, bool isListed, uint256 fee) = newEntityForgingContract.listings(99);
        // assertEq(account, address(0x1C51593463891B4F7D112A2a1ddFcD1eA75a3b7d));
        // assertEq(tokenId, 1716);
        // assertTrue(isListed);
        // assertEq(fee, 450_000_000_000_000_000);
    }
}

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
        uint256 index = newEntityForgingContract.listedTokenIds(2165);
        (address account, uint256 tokenId, bool isListed, uint256 fee) = newEntityForgingContract.listings(index);
        assertEq(account, address(0xb823c95Cd5aea92e287d7307750D2cE3BB2D6D43));
        assertEq(tokenId, 2165);
        assertTrue(isListed);
        assertEq(fee, 52_000_000_000_000_000);
    }
}

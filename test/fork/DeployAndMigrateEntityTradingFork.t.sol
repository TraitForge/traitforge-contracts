// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import { Fork_Test } from "./Fork.t.sol";
import { FixEntityTrading } from "script/deployment/FixEntityTrading.s.sol";
import { EntityTrading } from "contracts/EntityTrading.sol";

contract DeployAndMigrateEntityTradingFork is Fork_Test {
    FixEntityTrading fixScript;

    function setUp() public override {
        super.setUp();
        fixScript = new FixEntityTrading();
    }

    function test_deployAndMigrateEntityTrading() public {
        EntityTrading newEntityTradingContract = EntityTrading(fixScript.run());
        uint256 index = newEntityTradingContract.listedTokenIds(1047);
        (address seller, uint256 tokenId, uint256 price, bool isActive) = newEntityTradingContract.listings(index);
        assertEq(seller, address(0x132960c34aD5fcc14eA153f751fef363C761DA99));
        assertEq(tokenId, 1047);
        assertEq(price, 5_000_000_000_000_000_000);
        assertTrue(isActive);
    }
}

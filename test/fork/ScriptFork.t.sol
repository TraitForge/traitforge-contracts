// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import { Fork_Test } from "./Fork.t.sol";
import { TraitForgeNft } from "contracts/TraitForgeNft.sol";
import { UpdateAdmins } from "script/deployment/UpdateAdmins.s.sol";
import { UpdateDevs } from "script/deployment/UpdateDevs.s.sol";

contract ScriptForkTest is Fork_Test {
    UpdateAdmins updateAdmins;
    UpdateDevs updateDevs;

    function setUp() public override {
        super.setUp();
        updateAdmins = new UpdateAdmins();
        updateDevs = new UpdateDevs();
    }

    function test_updateDevs() public {
        updateDevs.run();
    }

    function test_updateAdmins() public {
        updateAdmins.run();
    }
}

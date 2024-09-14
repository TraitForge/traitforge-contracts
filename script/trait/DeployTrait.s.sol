// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Trait} from "contracts/Trait.sol";

contract DeployTrait is Script {
    Trait public trait;

    function run() public returns (Trait) {
        vm.startBroadcast();
        trait = new Trait("Trait", "TRAIT", 18, 1_000_000 ether);
        vm.stopBroadcast();

        return trait;
    }
}

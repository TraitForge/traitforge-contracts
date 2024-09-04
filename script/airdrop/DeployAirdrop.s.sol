// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Airdrop} from "contracts/Airdrop/Airdrop.sol";

contract DeployAirdrop is Script {
    Airdrop public airdrop;

    function setUp() public {}

    function run() public returns (Airdrop) {
        vm.startBroadcast();

        airdrop = new Airdrop();

        vm.stopBroadcast();

        return airdrop;
    }
}

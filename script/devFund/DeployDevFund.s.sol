// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DevFund} from "contracts/DevFund/DevFund.sol";

contract DeployDevFund is Script {
    DevFund public devFund;

    function run() public {
        vm.startBroadcast();
        devFund = new DevFund();
        vm.stopBroadcast();
    }
}
// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { console } from "@forge-std/console.sol";

import { EntropyGenerator } from "contracts/EntropyGenerator.sol";

contract DeployEntropyGenerator is BaseScript {
    function run() public virtual initConfig broadcast {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        address newEntropyGeneratorAddress = _deployEntropyGenerator();
        console.log("EntropyGenerator deployed at address: ", newEntropyGeneratorAddress);
    }

    function _deployEntropyGenerator() internal returns (address) {
        return address(new EntropyGenerator(addressProvider));
    }
}

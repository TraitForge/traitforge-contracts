// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { console } from "@forge-std/console.sol";

import { EntityForging } from "contracts/EntityForging.sol";

contract DeployEntityForging is BaseScript {
    function run() public virtual initConfig broadcast {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        address newEntityForging = _deployEntityForging();
        console.log("EntityForging deployed at address: ", newEntityForging);
    }

    function _deployEntityForging() internal returns (address) {
        return address(new EntityForging(addressProvider));
    }
}

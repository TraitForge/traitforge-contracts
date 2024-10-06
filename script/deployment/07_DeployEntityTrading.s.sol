// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { console } from "@forge-std/console.sol";

import { EntityTrading } from "contracts/EntityTrading.sol";

contract DeployEntityTrading is BaseScript {
    function run() public virtual initConfig broadcast {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        address newEntityTrading = _deployEntityTrading();
        console.log("EntityTrading deployed at address: ", newEntityTrading);
    }

    function _deployEntityTrading() internal returns (address) {
        return address(new EntityTrading(addressProvider));
    }
}

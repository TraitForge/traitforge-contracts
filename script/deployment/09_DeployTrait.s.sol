// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { console } from "@forge-std/console.sol";

import { Trait } from "contracts/Trait.sol";

contract DeployTrait is BaseScript {
    function run() public virtual initConfig broadcast {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        address newTraitAddress = _deployTrait();
        console.log("Trait deployed at address: ", newTraitAddress);
    }

    function _deployTrait() internal returns (address) {
        return address(new Trait("Trait", "TRAIT", 18, 1_000_000 ether));
    }
}

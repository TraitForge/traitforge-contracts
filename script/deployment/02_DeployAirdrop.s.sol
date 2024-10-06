// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { console } from "@forge-std/console.sol";

import { Airdrop } from "contracts/Airdrop.sol";

contract DeployAirdrop is BaseScript {
    function run() public virtual initConfig broadcast {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }
        address newAirdropAddress = _deployAirdrop();
        console.log("Airdrop deployed at address: ", newAirdropAddress);
    }

    function _deployAirdrop() internal returns (address) {
        return address(new Airdrop(addressProvider));
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { console } from "@forge-std/console.sol";

import { TraitForgeNft } from "contracts/TraitForgeNft.sol";

contract DeployTraitForgeNft is BaseScript {
    error RootHashIsZero();

    function run() public virtual initConfig broadcast {
        if (rootHash == bytes32(0)) {
            revert RootHashIsZero();
        }
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        address nft = _deployTraitForgeNft();
        console.log("TraitForgeNft deployed at address: ", nft);
    }

    function _deployTraitForgeNft() internal returns (address) {
        return address(new TraitForgeNft(addressProvider, rootHash));
    }
}

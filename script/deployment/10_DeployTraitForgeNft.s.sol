// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";
import { Roles } from "contracts/libraries/Roles.sol";

import { TraitForgeNft } from "contracts/TraitForgeNft.sol";

contract DeployTraitForgeNft is BaseScript {
    function run() public virtual initConfig broadcast {
        if (traitForgeNft != address(0)) {
            revert AlreadyDeployed();
        }

        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        AddressProvider ap = AddressProvider(addressProvider);
        address nft = _deployTraitForgeNft();
        ap.setTraitForgeNft(nft);
    }

    function _deployTraitForgeNft() internal returns (address) {
        return address(new TraitForgeNft(addressProvider));
    }
}

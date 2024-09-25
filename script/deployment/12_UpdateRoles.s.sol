// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";
import { Roles } from "contracts/libraries/Roles.sol";

contract UpdateRoles is BaseScript {
    function run() public virtual initConfig broadcast {

        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        AddressProvider ap = AddressProvider(addressProvider);
        

        ////////////////////  Grant Roles  ////////////////////
        ap.getAccessController().grantRole(Roles.AIRDROP_ACCESSOR, address(traitForgeNft));
        ap.getAccessController().grantRole(Roles.ENTROPY_ACCESSOR, address(traitForgeNft));
    }
}

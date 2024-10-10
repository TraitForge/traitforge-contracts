// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { console } from "@forge-std/console.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";

import { EntityForging } from "contracts/EntityForging.sol";
import { IEntityForging } from "contracts/interfaces/IEntityForging.sol";

contract FixEntityForging is BaseScript {
    EntityForging.Listing[] public listings;
    uint256 public count;

    function run() public virtual initConfig returns (address) {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        // HERE is The former EntityForging address
        address formerEntityForging = AddressProvider(addressProvider).getEntityForging();
        console.log("former EntityForging is at address: ", formerEntityForging);

        address newEntityForging = address(0xCAD8EfdF86252FB024F4E03cC1Fa44f8130d2FAf);
        console.log("new EntityForging is at address: ", newEntityForging);

        /////////////////// MIGRATING DATA ///////////////////
        _migrateEntityForgingData(formerEntityForging, newEntityForging);
        return newEntityForging;
    }

    function _deployEntityForging() internal returns (address) {
        return address(new EntityForging(addressProvider));
    }

    function _migrateEntityForgingData(address _formerEntityForging, address _newEntityForging) internal {
        count = EntityForging(_formerEntityForging).listingCount();
        for (uint256 i = 1; i <= count; i++) {
            EntityForging.Listing memory l = EntityForging(_formerEntityForging).getListings(i);
            if (l.isListed) {
                listings.push(l);
            }
        }

        console.log("listings: ", listings.length);
        console.log("count: ", count);

        // uint256 deployerKey = vm.envUint("DEPLOYER_KEY");
        vm.startBroadcast(address(0x225b791581185B73Eb52156942369843E8B0Eec7));
        EntityForging(_newEntityForging).migrateListingData(listings, count);
        vm.stopBroadcast();
    }
}

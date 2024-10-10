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
        address formerEntityForging = address(0xE1d5493b321d16e12c747bEc0E1ab4d4dBBf1AF9);
        console.log("former EntityForging is at address: ", formerEntityForging);

        address newEntityForging = AddressProvider(addressProvider).getEntityForging();
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
            (address account, uint256 tokenId, bool isListed, uint256 fee) =
                EntityForging(_formerEntityForging).listings(i);
            EntityForging.Listing memory l = IEntityForging.Listing(account, tokenId, isListed, fee);
            if (l.isListed) {
                listings.push(l);
            }
        }

        console.log("listings: ", listings.length);
        console.log("count: ", count);

        uint256 deployerKey = vm.envUint("DEPLOYER_KEY");
        vm.startBroadcast(deployerKey);
        EntityForging(_newEntityForging).migrateListingData(listings, count);
        vm.stopBroadcast();
    }
}

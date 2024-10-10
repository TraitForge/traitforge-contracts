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
        // uint256 deployerKey = vm.envUint("DEPLOYER_KEY");
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        address currentEntityForging = AddressProvider(addressProvider).getEntityForging();

        vm.startBroadcast(address(0x225b791581185B73Eb52156942369843E8B0Eec7));
        address newEntityForging = _deployEntityForging();
        vm.stopBroadcast();
        console.log("new EntityForging deployed at address: ", newEntityForging);

        /////////////////// MIGRATING DATA ///////////////////
        _migrateEntityForgingData(currentEntityForging, newEntityForging);
        return newEntityForging;
    }

    function _deployEntityForging() internal returns (address) {
        return address(new EntityForging(addressProvider));
    }

    function _migrateEntityForgingData(address currentEntityForging, address newEntityForging) internal {
        count = EntityForging(currentEntityForging).listingCount();
        for (uint256 i = 1; i <= count; i++) {
            (address account, uint256 tokenId, bool isListed, uint256 fee) =
                EntityForging(currentEntityForging).listings(i);
            EntityForging.Listing memory l = IEntityForging.Listing(account, tokenId, isListed, fee);
            if (l.isListed) {
                listings.push(l);
            }
        }

        // uint256 deployerKey = vm.envUint("DEPLOYER_KEY");
        vm.startBroadcast(address(0x225b791581185B73Eb52156942369843E8B0Eec7));
        EntityForging(newEntityForging).migrateListingData(listings, count);
        vm.stopBroadcast();
    }
}

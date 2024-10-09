// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { console } from "@forge-std/console.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";

import { EntityTrading } from "contracts/EntityTrading.sol";
import { IEntityTrading } from "contracts/interfaces/IEntityTrading.sol";

contract FixEntityTrading is BaseScript {
    IEntityTrading.Listing[] public listings;
    uint256 public count;

    function run() public virtual initConfig returns (address) {
        uint256 deployerKey = vm.envUint("DEPLOYER_KEY");
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        address currentEntityTrading = AddressProvider(addressProvider).getEntityTrading();

        vm.startBroadcast(deployerKey);
        address newEntityTrading = _deployEntityTrading();
        vm.stopBroadcast();
        console.log("EntityTrading deployed at address: ", newEntityTrading);

        /////////////////// MIGRATING DATA ///////////////////
        _migrateEntityTradingData(currentEntityTrading, newEntityTrading);
        return newEntityTrading;
    }

    function _deployEntityTrading() internal returns (address) {
        return address(new EntityTrading(addressProvider));
    }

    function _migrateEntityTradingData(address currentEntityTrading, address newEntityTrading) internal {
        // Migrate data from currentEntityTrading to newEntityTrading
        count = EntityTrading(currentEntityTrading).listingCount();
        for (uint256 i = 1; i <= count; i++) {
            (address seller, uint256 tokenId, uint256 price, bool isActive) =
                EntityTrading(currentEntityTrading).listings(i);
            IEntityTrading.Listing memory l = IEntityTrading.Listing(seller, tokenId, price, isActive);
            if (l.isActive) {
                listings.push(l);
            }
        }

        // Migrate data to newEntityTrading
        uint256 deployerKey = vm.envUint("DEPLOYER_KEY");
        vm.startBroadcast(deployerKey);
        EntityTrading(newEntityTrading).migrateData(listings, count);
        vm.stopBroadcast();
    }
}

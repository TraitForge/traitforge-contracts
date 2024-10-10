// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { EntityForgingTest } from "test/integration/concrete/entityForging/EntityForgingTest.t.sol";
import { EntityForging } from "contracts/EntityForging.sol";
import { IEntityForging } from "contracts/interfaces/IEntityForging.sol";

contract EntityForgingTest_MigrateListingData is EntityForgingTest {
    // function test_entityForging_migrateListingData() public {
    //     EntityForging.Listing memory l = IEntityForging.Listing(
    //         address(0xb823c95Cd5aea92e287d7307750D2cE3BB2D6D43), 2165, true, 52_000_000_000_000_000
    //     );
    //     EntityForging.Listing[] memory _listArray = new EntityForging.Listing[](1);
    //     _listArray[0] = l;
    //     vm.startPrank(_protocolMaintainer);
    //     _entityForging.migrateListingData(_listArray, 1);
    //     (address account, uint256 tokenId, bool isListed, uint256 fee) = _entityForging.listings(1);
    //     assertEq(account, address(0xb823c95Cd5aea92e287d7307750D2cE3BB2D6D43));
    //     assertEq(tokenId, 2165);
    //     assertTrue(isListed);
    //     assertEq(fee, 52_000_000_000_000_000);
    // }
}

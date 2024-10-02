// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { EntityForgingTest } from "test/integration/concrete/entityForging/EntityForgingTest.t.sol";
import { EntityForging } from "contracts/EntityForging.sol";

contract EntityForgingTest_CancelListingForForging is EntityForgingTest {
    uint256 fee = 0.02 ether;

    function testRevert_entityForging_cancelListingForForging_whenPaused() public {
        vm.prank(_protocolMaintainer);
        _entityForging.pause();

        vm.expectRevert(bytes("Pausable: paused"));
        vm.prank(_randomUser);
        _entityForging.cancelListingForForging(1);
    }

    function testRevert_entityForging_cancelListingForForging_whenCallerNotTokenOwner() public {
        _mintNFTs(user, 10);
        // we grab the first forger token id
        uint256 forgerId = _getTheNthForgerId(0, 10, 1);

        vm.prank(_randomUser);
        vm.expectRevert(EntityForging.EntityForging__TokenNotOwnedByCaller.selector);
        _entityForging.cancelListingForForging(forgerId);
    }

    function testRevert_entityForging_cancelListingForForging_whenTokenNotListed() public {
        _mintNFTs(user, 10);
        uint256 forgerId = _getTheNthForgerId(0, 10, 1);

        vm.prank(user);
        vm.expectRevert(
            abi.encodeWithSelector(EntityForging.EntityForging__TokenNotListedForForging.selector, forgerId)
        );
        _entityForging.cancelListingForForging(forgerId);
    }

    function test_entityForging_cancelListingForForging() public {
        _mintNFTs(user, 10);
        uint256 forgerId = _getTheNthForgerId(0, 10, 1);

        vm.startPrank(user);
        _entityForging.listForForging(forgerId, fee);
        _entityForging.cancelListingForForging(forgerId);
        assertEq(_entityForging.getListings(forgerId).isListed, false);
    }
}

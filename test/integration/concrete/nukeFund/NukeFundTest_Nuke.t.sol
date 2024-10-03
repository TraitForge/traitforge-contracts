// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { NukeFundTest } from "test/integration/concrete/nukeFund/NukeFundTest.t.sol";
import { NukeFund } from "contracts/NukeFund.sol";

contract NukeFundTest_Nuke is NukeFundTest {
    function testRevert_nukeFund_nuke_whenPaused() public {
        vm.prank(_protocolMaintainer);
        _nukeFund.pause();

        vm.expectRevert(bytes("Pausable: paused"));
        vm.prank(_randomUser);
        _nukeFund.nuke(1);
    }

    function testRevert_nukeFund_nuke_whenTokenOwnerIsNotTheCaller() public {
        _mintTraitForgeNft(user, 1);

        vm.expectRevert(NukeFund.NukeFund__CallerNotTokenOwner.selector);
        vm.prank(_randomUser);
        _nukeFund.nuke(1);
    }

    function testRevert_nukeFund_nuke_whenTokenNotApprovedByContract() public {
        _mintTraitForgeNft(user, 1);

        vm.expectRevert(NukeFund.NukeFund__ContractNotApproved.selector);
        vm.prank(user);
        _nukeFund.nuke(1);
    }

    function testRevert_nukeFund_nuke_whenTokenNotMature() public {
        _mintTraitForgeNft(user, 1);

        vm.startPrank(user);
        _traitForgeNft.approve(address(_nukeFund), 1);

        vm.expectRevert(NukeFund.NukeFund__TokenNotMature.selector);
        _nukeFund.nuke(1);
    }
}

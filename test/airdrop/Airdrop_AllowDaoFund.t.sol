// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AirdropTest} from "test/airdrop/AirdropTest.t.sol";
import {Airdrop} from "contracts/Airdrop/Airdrop.sol";

contract Airdrop_AllowDaoFund is AirdropTest {
    function testRevert_when_not_owner() public {
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        airdrop.allowDaoFund();
    }

    function testRevert_when_not_started() public {
        vm.prank(owner);
        vm.expectRevert(Airdrop.Airdrop__NotStarted.selector);
        airdrop.allowDaoFund();
    }

    function testRevert_when_amount_is_zero() public {
        vm.startPrank(owner);
        airdrop.setTraitToken(address(trait));
        vm.expectRevert(Airdrop.Airdrop__InvalidAmount.selector);
        airdrop.startAirdrop(0);
    }

    function testRevert_when_traitToken_is_zero() public {
        vm.startPrank(owner);
        vm.expectRevert(Airdrop.Airdrop__AddressZero.selector);
        airdrop.startAirdrop(amount);
    }

    function testRevert_when_dao_fund_already_allowed() public {
        _transferAndApproveTrait();
        airdrop.setTraitToken(address(trait));
        airdrop.startAirdrop(amount);

        airdrop.allowDaoFund();
        vm.expectRevert(Airdrop.Airdrop__AlreadyAllowed.selector);
        airdrop.allowDaoFund();
    }

    function test_allow_dao_fund() public {
        _transferAndApproveTrait();
        airdrop.setTraitToken(address(trait));
        airdrop.startAirdrop(amount);
        airdrop.allowDaoFund();

        assertEq(airdrop.daoFundAllowed(), true);
    }
}

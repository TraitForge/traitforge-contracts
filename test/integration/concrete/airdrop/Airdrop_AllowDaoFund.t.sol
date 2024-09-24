// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { AirdropTest } from "../airdrop/AirdropTest.t.sol";
import { Airdrop } from "contracts/Airdrop.sol";
import { Errors } from "contracts/libraries/Errors.sol";

contract Airdrop_AllowDaoFund is AirdropTest {
    function testRevert__airdrop__allowDao__whenNotAuthorized() public {
        vm.expectRevert(abi.encodeWithSelector(Errors.CallerNotAirdropAccessor.selector, _randomUser));
        vm.prank(_randomUser);
        _airdrop.allowDaoFund();
    }

    function testRevert__airdrop__allowDao__whenNotStarted() public {
        vm.prank(_airdropAccessor);
        vm.expectRevert(Airdrop.Airdrop__NotStarted.selector);
        _airdrop.allowDaoFund();
    }

    function testRevert__airdrop__allowDao__whenAmountIsZero() public {
        vm.startPrank(_airdropAccessor);
        vm.expectRevert(Airdrop.Airdrop__InvalidAmount.selector);
        _airdrop.startAirdrop(0);
    }

    function testRevert__airdrop__allowDao__whenDaoFundAlreadyAllowed() public {
        _startAirdrop();
        vm.startPrank(_airdropAccessor);
        _airdrop.allowDaoFund();
        vm.expectRevert(Airdrop.Airdrop__AlreadyAllowed.selector);
        _airdrop.allowDaoFund();
    }

    function test__airdrop__allowDao() public {
        _startAirdrop();
        vm.startPrank(_airdropAccessor);
        _airdrop.allowDaoFund();

        assertEq(_airdrop.daoFundAllowed(), true);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Deploys } from "test/shared/Deploys.sol";
import { Roles } from "contracts/libraries/Roles.sol";

contract AirdropTest is Deploys {
    address internal _airdropAccessor = makeAddr("_airdropAccessor");
    uint256 internal amount = 1_000_000 ether;

    function setUp() public virtual override {
        super.setUp();
        vm.prank(_defaultAdmin);
        _accessController.grantRole(Roles.AIRDROP_ACCESSOR, _airdropAccessor);
    }

    function _startAirdrop() internal {
        vm.prank(_traitMinter);
        _trait.transfer(_airdropAccessor, amount);
        vm.startPrank(_airdropAccessor);
        _trait.approve(address(_airdrop), amount);
        _airdrop.startAirdrop(amount);
        vm.stopPrank();
    }
}

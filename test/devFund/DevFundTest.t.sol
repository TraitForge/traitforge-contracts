// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";
import { DevFund } from "contracts/DevFund.sol";
import { Deploys } from "test/shared/Deploys.sol";
import { Roles } from "contracts/libraries/Roles.sol";

contract DevFundTest is Deploys {
    event AddDev(address indexed dev, uint256 weight);
    event UpdateDev(address indexed dev, uint256 weight);
    event RemoveDev(address indexed dev);
    event Claim(address indexed dev, uint256 amount);
    event FundReceived(address indexed from, uint256 amount);

    address internal _devFundAccessor = makeAddr("airdropAccessor");
    address internal _dev = makeAddr("dev");

    function setUp() public virtual override {
        super.setUp();
        vm.prank(_defaultAdmin);
        _accessController.grantRole(Roles.DEVFUND_ACCESSOR, _devFundAccessor);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DevFund} from "contracts/DevFund/DevFund.sol";

contract DevFundTest is Test {
    event AddDev(address indexed dev, uint256 weight);
    event UpdateDev(address indexed dev, uint256 weight);
    event RemoveDev(address indexed dev);
    event Claim(address indexed dev, uint256 amount);
    event FundReceived(address indexed from, uint256 amount);

    DevFund public devFund;
    address public owner = makeAddr("owner");

    function setUp() public virtual {
        vm.prank(owner);
        devFund = new DevFund();
    }
}

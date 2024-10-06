// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Deploys } from "test/shared/Deploys.sol";

contract EntityForgingTest is Deploys {
    address public user = makeAddr("user");
    address public otherUser = makeAddr("otherUser");

    function setUp() public virtual override {
        super.setUp();
        deal(user, 1_000_000 ether);
        deal(otherUser, 1_000_000 ether);
    }
}

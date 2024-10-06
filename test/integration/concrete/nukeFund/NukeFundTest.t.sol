// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Deploys } from "test/shared/Deploys.sol";

contract NukeFundTest is Deploys {
    address public user = makeAddr("user");

    function setUp() public virtual override {
        super.setUp();
        deal(user, 1_000_000 ether);
    }

    function _skipNukeMinimumDaysHeld() internal {
        uint256 _minimumDaysHeld = _nukeFund.minimumDaysHeld();
        skip(_minimumDaysHeld + 1);
    }
}

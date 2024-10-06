// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { TraitForgeNft } from "contracts/TraitForgeNft.sol";
import { Deploys } from "test/shared/Deploys.sol";

contract TraitForgeNftTest is Deploys {
    address public user = makeAddr("user");

    function setUp() public virtual override {
        super.setUp();
        deal(user, 1_000_000 ether);
    }
}

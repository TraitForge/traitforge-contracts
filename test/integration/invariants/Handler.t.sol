// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Test } from "@forge-std/Test.sol";
import { TraitForgeNft } from "contracts/TraitForgeNft.sol";

contract Handler is Test {
    TraitForgeNft public traitForgeNft;

    constructor(TraitForgeNft _traitForgeNft) {
        traitForgeNft = _traitForgeNft;
    }

    function singleMint() public {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        uint256 price = traitForgeNft.calculateMintPrice();
        vm.deal(msg.sender, price);
        vm.prank(msg.sender);
        traitForgeNft.mintToken{ value: price }(proofs);
    }

    function mintWithBudget(uint96 value) public {
        _skipWhitelistTime();
        uint256 price = traitForgeNft.calculateMintPrice();
        uint256 budget = bound(uint256(value), price, 1 ether);
        bytes32[] memory proofs = new bytes32[](0);
        vm.deal(msg.sender, budget);
        vm.prank(msg.sender);
        traitForgeNft.mintWithBudget{ value: budget }(proofs, 1);
    }

    function _skipWhitelistTime() internal {
        uint256 _endWhitheListTimestamp = traitForgeNft.whitelistEndTime();
        skip(_endWhitheListTimestamp + 1);
    }
}

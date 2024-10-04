// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Test, console } from "@forge-std/Test.sol";
import { TraitForgeNft } from "contracts/TraitForgeNft.sol";

contract Handler is Test {
    TraitForgeNft public traitForgeNft;

    constructor(TraitForgeNft _traitForgeNft) {
        traitForgeNft = _traitForgeNft;
        _skipWhitelistTime();
    }

    function singleMint() public {
        bytes32[] memory proofs = new bytes32[](0);
        uint256 price = traitForgeNft.calculateMintPrice();
        vm.deal(msg.sender, price);
        vm.prank(msg.sender);
        traitForgeNft.mintToken{ value: price }(proofs);
    }

    // function mintWithBudget() public {
    //     uint256 price = traitForgeNft.calculateMintPrice();
    //     bytes32[] memory proofs = new bytes32[](0);
    //     vm.deal(msg.sender, price);
    //     vm.prank(msg.sender);
    //     traitForgeNft.mintWithBudget{ value: price }(proofs, 1);
    // }

    function _skipWhitelistTime() internal {
        uint256 _endWhitheListTimestamp = traitForgeNft.whitelistEndTime();
        skip(_endWhitheListTimestamp + 1);
    }
}

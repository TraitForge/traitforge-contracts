// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import { Fork_Test } from "./Fork.t.sol";
import { TraitForgeNft } from "contracts/TraitForgeNft.sol";

contract TraitForgeNftForkTest is Fork_Test {
    function setUp() public override {
        super.setUp();
    }

    // function test_traitForgeNftFork__mintToken() public {
    //     TraitForgeNft nft = TraitForgeNft(traitForgeNft);

    //     vm.prank(address(0x225b791581185B73Eb52156942369843E8B0Eec7));
    //     bytes32[] memory proofs = new bytes32[](2);
    //     proofs[0] = bytes32(0xccde2ddaf58b1f916d5359378d87667005516a28fb95b92cffadebf464f8240b);
    //     proofs[1] = bytes32(0xc8fbcb936bf99fdc0fe0524b9a208cf8c60d1fbc93de9d08ab1d204b91dd7a47);
    //     nft.mintToken{value: 0.005 ether}(proofs);
    // }
}

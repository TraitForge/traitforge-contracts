// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Deploys } from "test/shared/Deploys.sol";
import { Handler } from "test/integration/invariants/Handler.t.sol";
import { console } from "@forge-std/console.sol";

contract MaxTokenInvariantsTest is Deploys {
    Handler public handler;

    function setUp() public virtual override {
        super.setUp();
        handler = new Handler(_traitForgeNft);
        targetContract(address(handler));
    }

    function invariant_cannotExceedMaxTokenPerGen() public view {
        uint256 maxTokensPerGen = _traitForgeNft.maxTokensPerGen();
        uint256 maxGenrationCount = _traitForgeNft.maxGeneration();

        for (uint256 i = 0; i < maxGenrationCount; i++) {
            uint256 mintTokensGen = _traitForgeNft.generationMintCounts(i + 1);
            assert(mintTokensGen <= maxTokensPerGen);
        }
    }

    function invariant_cannotExceedTotalSupply() public view {
        uint256 maxTokensPerGen = _traitForgeNft.maxTokensPerGen();
        uint256 maxGenrationCount = _traitForgeNft.maxGeneration();
        uint256 totalSupply = _traitForgeNft.totalSupply();

        assert(totalSupply <= maxTokensPerGen * maxGenrationCount);
    }
}

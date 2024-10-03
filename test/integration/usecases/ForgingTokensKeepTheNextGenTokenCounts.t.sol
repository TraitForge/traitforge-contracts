// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Deploys } from "test/shared/Deploys.sol";

contract ForgingTokensKeepTheNextGenTokenCounts is Deploys {
    address public user = makeAddr("user");

    function setUp() public virtual override {
        super.setUp();
        deal(user, 1_000_000 ether);
    }

    function test_forgingTokensKeepTheNextGenTokenCounts() public {
        // first we mint half of the first generation
        uint256 maxTokensPerGen = _traitForgeNft.maxTokensPerGen();
        _mintTraitForgeNft(user, maxTokensPerGen / 2);

        uint256 forgerId1 = _getTheNthForgerId(0, maxTokensPerGen / 2, 1);
        uint256 forgerId2 = _getTheNthForgerId(0, maxTokensPerGen / 2, 2);
        uint256 mergerId1 = _getTheNthMergerId(0, maxTokensPerGen / 2, 1);
        uint256 mergerId2 = _getTheNthMergerId(0, maxTokensPerGen / 2, 2);

        //we forge
        vm.startPrank(user);
        _entityForging.listForForging(forgerId1, 0.02 ether);
        _entityForging.listForForging(forgerId2, 0.02 ether);
        _entityForging.forgeWithListed{ value: 0.02 ether }(forgerId1, mergerId1);
        _entityForging.forgeWithListed{ value: 0.02 ether }(forgerId2, mergerId2);
        vm.stopPrank();

        assertEq(_traitForgeNft.generationMintCounts(2), 2);

        //we mint other half of the first generation
        _mintTraitForgeNft(user, maxTokensPerGen / 2);

        //we still have the first 2 forge tokens for 2nd generation
        assertEq(_traitForgeNft.generationMintCounts(2), 2);

        //now we mint the next 100 tokens
        _mintTraitForgeNft(user, 100);

        assertEq(_traitForgeNft.generationMintCounts(2), 102);
    }
}

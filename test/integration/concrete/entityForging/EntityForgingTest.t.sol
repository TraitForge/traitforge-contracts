// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Deploys } from "test/shared/Deploys.sol";

contract EntityForgingTest is Deploys {
    mapping(uint256 tokenId => bool) isTokenForger;
    mapping(uint256 tokenId => bool) isTokenMerger;
    mapping(uint256 tokenId => bool) isTokenNoPotentialForger;
    mapping(uint256 tokenId => bool) isTokenNoPotentialMerger;
    address public user = makeAddr("user");
    address public otherUser = makeAddr("otherUser");

    function setUp() public virtual override {
        super.setUp();
        deal(user, 1_000_000 ether);
        deal(otherUser, 1_000_000 ether);
    }

    function _skipWhitelistTime() internal {
        uint256 _endWhitheListTimestamp = _traitForgeNft.whitelistEndTime();
        skip(_endWhitheListTimestamp + 1);
    }

    function _mintNFTs(address _user, uint256 _amount) internal {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        for (uint256 i = 0; i < _amount; i++) {
            uint256 price = _traitForgeNft.calculateMintPrice();
            vm.startPrank(_user);
            uint256 tokenId = _traitForgeNft.mintToken{ value: price }(proofs);
            if (_traitForgeNft.isForger(tokenId)) {
                if ((_traitForgeNft.getTokenEntropy(tokenId) / 10) % 10 > 0) {
                    isTokenForger[tokenId] = true;
                } else {
                    isTokenNoPotentialForger[tokenId] = true;
                }
            } else {
                if ((_traitForgeNft.getTokenEntropy(tokenId) / 10) % 10 > 0) {
                    isTokenMerger[tokenId] = true;
                } else {
                    isTokenNoPotentialMerger[tokenId] = true;
                }
            }
            vm.stopPrank();
        }
    }

    function _getTheNthForgerId(
        uint256 startIndex,
        uint256 endIndex,
        uint256 n
    )
        internal
        view
        returns (uint256 theNthTokenId)
    {
        uint256 count = 0;
        for (uint256 i = startIndex; i < endIndex; i++) {
            if (isTokenForger[i + 1]) {
                count++;
                if (count == n) {
                    theNthTokenId = i + 1;
                }
            }
        }
    }

    function _getTheNthMergerId(
        uint256 startIndex,
        uint256 endIndex,
        uint256 n
    )
        internal
        view
        returns (uint256 theNthTokenId)
    {
        uint256 count = 0;
        for (uint256 i = startIndex; i < endIndex; i++) {
            if (isTokenMerger[i + 1]) {
                count++;
                if (count == n) {
                    theNthTokenId = i + 1;
                }
            }
        }
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import '../lib/forge-std/src/Test.sol';
import { console2 } from '../lib/forge-std/src/console2.sol';
import '../contracts/TraitForgeNft/TraitForgeNft.sol';
import '../contracts/EntropyGenerator/EntropyGenerator.sol';
import '../contracts/EntityForging/EntityForging.sol';
import '../contracts/Airdrop/Airdrop.sol';
import '../contracts/NukeFund/NukeFund.sol';

contract EntropyGeneratorTest is Test {
    TraitForgeNft public forgeNFT;
    EntropyGenerator public entropyGenerator;
    EntityForging public forgingContract;
    Airdrop public airdrop;
    NukeFund public nukeFund;
    address dev = makeAddr('dev');
    address dao = makeAddr('dao');

    function setUp() public {
        forgeNFT = new TraitForgeNft();
        entropyGenerator = new EntropyGenerator(address(forgeNFT));
        forgingContract = new EntityForging(address(forgeNFT));
        airdrop = new Airdrop();
        airdrop.transferOwnership(address(forgeNFT));
        nukeFund = new NukeFund(
            address(forgeNFT),
            address(airdrop),
            payable(dev),
            payable(dao)
        );

        forgeNFT.setEntityForgingContract(address(forgingContract));
        forgeNFT.setEntropyGenerator(address(entropyGenerator));
        forgeNFT.setAirdropContract(address(airdrop));
    }

    function test_matureToSlowly() public {
        address user = makeAddr('user');
        vm.deal(user, 100000e18);
        bytes32[] memory proof;

        uint256 initialNukeFactor;
        uint256 performanceFactor;
        uint256 tokenId = 0;

        vm.warp(1722790420);
        vm.warp(block.timestamp + 48 hours);

        while (initialNukeFactor != 24999 && performanceFactor != 9) {
            vm.prank(user);
            forgeNFT.mintToken{ value: 2e18 }(proof);
            tokenId++;
            initialNukeFactor = forgeNFT.getTokenEntropy(tokenId) / 40;
            performanceFactor = forgeNFT.getTokenEntropy(tokenId) % 10;
        }
        // Almost perfect NFT
        console2.log('initialNukeFactor:', initialNukeFactor);
        console2.log('performanceFactor:', performanceFactor);
        console2.log('--------------------------------------');

        // Judging by the docs this NFT should take around 30 days to mature fully
        vm.warp(block.timestamp + 30 days);

        // In 30 days NFT did not mature at all
        console2.log(
            'nukeFactor after 30 days: ',
            nukeFund.calculateNukeFactor(tokenId)
        );
        console2.log(
            'How much NFT matured:',
            nukeFund.calculateNukeFactor(tokenId) - initialNukeFactor
        );

        // It takes around 4000 days for an NFT to mature in perfect conditions
        vm.warp(block.timestamp + 4000 days);
        console2.log(
            'nukeFactor after 4000 days: ',
            nukeFund.calculateNukeFactor(tokenId)
        );
        console2.log(
            'How much NFT matured:',
            nukeFund.calculateNukeFactor(tokenId) - initialNukeFactor
        );
    }
}
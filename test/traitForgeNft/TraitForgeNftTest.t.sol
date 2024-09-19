// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TraitForgeNft} from "contracts/TraitForgeNft.sol";

contract TraitForgeNftTest is Test {
    event Minted(
        address indexed minter,
        uint256 indexed itemId,
        uint256 indexed generation,
        uint256 entropyValue,
        uint256 mintPrice
    );
    event NewEntityMinted(address indexed owner, uint256 indexed tokenId, uint256 indexed generation, uint256 entropy);
    event GenerationIncremented(uint256 newGeneration);
    event FundsDistributedToNukeFund(address indexed to, uint256 amount);
    event NukeFundContractUpdated(address nukeFundAddress);

    TraitForgeNft public tfNft;
    address public owner = makeAddr("owner");

    function setUp() public virtual {
        vm.prank(owner);
        tfNft = new TraitForgeNft(address(0x0A));
    }

    function _deactivateWhitelist() internal {
        vm.prank(owner);
        tfNft.setWhitelistEndTime(0);
    }
}

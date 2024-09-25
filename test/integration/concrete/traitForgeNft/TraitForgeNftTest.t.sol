// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { TraitForgeNft } from "contracts/TraitForgeNft.sol";
import { Deploys } from "test/shared/Deploys.sol";

contract TraitForgeNftTest is Deploys {
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

    address public owner = makeAddr("owner");

    function setUp() public override virtual {
        super.setUp();
    }

    function _deactivateWhitelist() internal {
        vm.prank(_protocolMaintainer);
        _traitForgeNft.setWhitelistEndTime(0);
    }
}

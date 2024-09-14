// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Airdrop} from "contracts/Airdrop.sol";
import {Trait} from "contracts/Trait.sol";
import {DeployAirdrop} from "script/airdrop/DeployAirdrop.s.sol";
import {DeployTrait} from "script/trait/DeployTrait.s.sol";

contract AirdropTest is Test {
    Airdrop public airdrop;
    Trait public trait;
    address public owner;
    address minter = makeAddr("minter");
    uint256 public amount = 1_000_000 ether;

    function setUp() public virtual {
        vm.prank(minter);
        trait = new Trait("Trait", "TRAIT", 18, amount);
        airdrop = (new DeployAirdrop()).run();
        owner = airdrop.owner();
    }

    function _transferAndApproveTrait() internal {
        vm.prank(minter);
        trait.transfer(owner, amount);

        vm.startPrank(owner);
        trait.approve(address(airdrop), amount);
    }

    function _startAirdrop() internal {
        _transferAndApproveTrait();
        airdrop.setTraitToken(address(trait));
        airdrop.startAirdrop(amount);
        vm.stopPrank();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { console } from "@forge-std/console.sol";

import { Airdrop } from "contracts/Airdrop.sol";
import { DevFund } from "contracts/DevFund.sol";
import { DAOFund } from "contracts/DAOFund.sol";
import { NukeRouter } from "contracts/NukeRouter.sol";
import { NukeFund } from "contracts/NukeFund.sol";
import { LottFund } from "contracts/LottFund.sol";
import { EntityForging } from "contracts/EntityForging.sol";
import { EntityTrading } from "contracts/EntityTrading.sol";
import { EntropyGenerator } from "contracts/EntropyGenerator.sol";
import { Trait } from "contracts/Trait.sol";
import { TraitForgeNft } from "contracts/TraitForgeNft.sol";

contract DeployAll is BaseScript {
    function run() public virtual initConfig broadcast {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        address newAirdropAddress = _deployAirdrop();
        address newDevFundAddress = _deployDevFund();
        // address newDaoFundAddress = _deployDaoFund();
        address newLottFundAddress = _deployLottFund();
        address newNukeFundAddress = _deployNukeFund();
        address newFundRouterAddress = _deployNukeRouter();
        address newEntityForgingAddress = _deployEntityForging();
        address newEntityTradingAddress = _deployEntityTrading();
        address newEntropyGeneratorAddress = _deployEntropyGenerator();
        address newTraitAddress = _deployTrait();
        address newTraitForgeNftAddress = _deployTraitForgeNft();

        console.log("Airdrop deployed at address: ", newAirdropAddress);
        console.log("DevFund deployed at address: ", newDevFundAddress);
        // console.log("DAOFund deployed at address: ", newDaoFundAddress);
        console.log("NukeFund deployed at address: ", newNukeFundAddress);
        console.log("LottFund deployed at address: ", newLottFundAddress);
        console.log("FundRouter deployed at address: ", newFundRouterAddress);
        console.log("EntityForging deployed at address: ", newEntityForgingAddress);
        console.log("EntityTrading deployed at address: ", newEntityTradingAddress);
        console.log("EntropyGenerator deployed at address: ", newEntropyGeneratorAddress);
        console.log("Trait deployed at address: ", newTraitAddress);
        console.log("TraitForgeNft deployed at address: ", newTraitForgeNftAddress);

        console.log("All contracts deployed successfully, please update the config file with the new addresses");
    }

    function _deployAirdrop() internal returns (address) {
        return address(new Airdrop(addressProvider));
    }

    function _deployDevFund() internal returns (address) {
        return address(new DevFund(addressProvider, ethCollector));
    }

    // function _deployDaoFund() internal returns (address) {
    //     return address(new DAOFund(uniswapRouter, addressProvider));
    // }

    function _deployNukeFund() internal returns (address) {
        return address(new NukeFund(addressProvider, ethCollector));
    }

    function _deployLottFund() internal returns (address) {
        return address(new LottFund(addressProvider, ethCollector, nukeFund, subscriptionId, vrfCoordinator));
    }

    function _deployNukeRouter() internal returns (address) {
        return address(new NukeRouter(addressProvider, nukeFund, lottFund));
    }

    function _deployEntityForging() internal returns (address) {
        return address(new EntityForging(addressProvider));
    }

    function _deployEntityTrading() internal returns (address) {
        return address(new EntityTrading(addressProvider));
    }

    function _deployEntropyGenerator() internal returns (address) {
        return address(new EntropyGenerator(addressProvider));
    }

    function _deployTrait() internal returns (address) {
        return address(new Trait("Trait", "TRAIT", 18, 1_000_000 ether));
    }

    function _deployTraitForgeNft() internal returns (address) {
        return address(new TraitForgeNft(addressProvider, rootHash));
    }
}

// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import { StdChains, VmSafe } from "@forge-std/StdChains.sol";

import { Config, ConfigLib } from "config/ConfigLib.sol";

contract Configured is StdChains {
    using ConfigLib for Config;

    VmSafe private constant vm = VmSafe(address(uint160(uint256(keccak256("hevm cheat code")))));

    Chain internal chain;
    Config internal config;

    string internal configFilePath;

    address internal defaultAdmin;
    address internal protocolMaintainer;
    address internal accessController;
    address internal addressProvider;

    address internal airdrop;
    address internal daoFund;
    address internal devFund;
    address internal entityForging;
    address internal entityTrading;
    address internal entropyGenerator;
    address internal nukeFund;
    address internal trait;
    address internal traitForgeNft;
    address internal ethCollector;
    address internal uniswapRouter;

    function _network() internal virtual returns (string memory) {
        Chain memory currentChain = getChain(block.chainid);
        return currentChain.chainAlias;
    }

    function _initConfig() internal returns (Config storage) {
        if (bytes(config.json).length == 0) {
            string memory root = vm.projectRoot();
            configFilePath = string.concat(root, "/config/", _network(), ".json");

            config.json = vm.readFile(configFilePath);
        }

        return config;
    }

    function _loadConfig() internal virtual {
        string memory rpcAlias = config.getRpcAlias();

        chain = getChain(rpcAlias);

        defaultAdmin = config.getDefaultAdminAddress();
        protocolMaintainer = config.getProtocolMaintainerAddress();
        accessController = config.getAccessControllerAddress();
        addressProvider = config.getAddressProviderAddress();

        airdrop = config.getAirdropAddress();
        daoFund = config.getDaoFundAddress();
        devFund = config.getDevFundAddress();
        entityForging = config.getEntityForgingAddress();
        entityTrading = config.getEntityTradingAddress();
        entropyGenerator = config.getEntropyGeneratorAddress();
        nukeFund = config.getNukeFundAddress();
        trait = config.getTraitAddress();
        traitForgeNft = config.getTraitForgeNftAddress();
        ethCollector = config.getEthCollectorAddress();
        uniswapRouter = config.getUniswapRouterAddress();
    }
}

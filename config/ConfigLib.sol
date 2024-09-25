// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import { console2 } from "@forge-std/console2.sol";
import { stdJson } from "@forge-std/StdJson.sol";

struct Config {
    string json;
}

library ConfigLib {
    using stdJson for string;

    string internal constant RPC_ALIAS = "$.rpcAlias";
    string internal constant IS_TESTNET = "$.isTestnet";
    string internal constant DEFAULT_ADMIN_ADDRESS = "$.defaultAdminAddress";
    string internal constant PROTOCOL_MAINTAINER = "$.protocolMaintainerAddress";
    string internal constant ACCESS_CONTROLLER = "$.accessController";
    string internal constant ADDRESS_PROVIDER = "$.addressProvider";
    string internal constant AIRDROP = "$.airdrop";
    string internal constant DAO_FUND = "$.daoFund";
    string internal constant DEV_FUND = "$.devFund";
    string internal constant ENTITY_FORGING = "$.entityForging";
    string internal constant ENTITY_TRADING = "$.entityTrading";
    string internal constant ENTROPY_GENERATOR = "$.entropyGenerator";
    string internal constant NUKE_FUND = "$.nukeFund";
    string internal constant TRAIT = "$.trait";
    string internal constant TRAIT_FORGE_NFT = "$.traitForgeNft";
    string internal constant ETH_COLLECTOR = "$.ethCollector";
    string internal constant UNISWAP_ROUTER = "$.uniswapRouter";
    string internal constant ROOT_HASH = "$.rootHash";

    function getAddress(Config storage config, string memory key) internal view returns (address) {
        return config.json.readAddress(string.concat("$.", key));
    }

    function getAddressArray(
        Config storage config,
        string[] memory keys
    )
        internal
        view
        returns (address[] memory addresses)
    {
        addresses = new address[](keys.length);

        for (uint256 i; i < keys.length; ++i) {
            addresses[i] = getAddress(config, keys[i]);
        }
    }

    function getIsTestnet(Config storage config) internal view returns (bool) {
        return config.json.readBool(IS_TESTNET);
    }

    function getRpcAlias(Config storage config) internal view returns (string memory) {
        return config.json.readString(RPC_ALIAS);
    }

    function getDefaultAdminAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(DEFAULT_ADMIN_ADDRESS);
    }

    function getProtocolMaintainerAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(PROTOCOL_MAINTAINER);
    }

    function getAccessControllerAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(ACCESS_CONTROLLER);
    }

    function getAddressProviderAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(ADDRESS_PROVIDER);
    }

    function getAirdropAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(AIRDROP);
    }

    function getDaoFundAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(DAO_FUND);
    }

    function getDevFundAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(DEV_FUND);
    }

    function getEntityForgingAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(ENTITY_FORGING);
    }

    function getEntityTradingAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(ENTITY_TRADING);
    }

    function getEntropyGeneratorAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(ENTROPY_GENERATOR);
    }

    function getNukeFundAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(NUKE_FUND);
    }

    function getTraitAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(TRAIT);
    }

    function getTraitForgeNftAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(TRAIT_FORGE_NFT);
    }

    function getEthCollectorAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(ETH_COLLECTOR);
    }

    function getUniswapRouterAddress(Config storage config) internal view returns (address) {
        return config.json.readAddress(UNISWAP_ROUTER);
    }

    function getRootHash(Config storage config) internal view returns (bytes32) {
        return config.json.readBytes32(ROOT_HASH);
    }
}

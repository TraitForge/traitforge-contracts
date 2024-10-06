// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

library Roles {
    bytes32 public constant AIRDROP_ACCESSOR = keccak256("AIRDROP_ACCESSOR");
    bytes32 public constant DAO_FUND_ACCESSOR = keccak256("DAO_FUND_ACCESSOR");
    bytes32 public constant DEV_FUND_ACCESSOR = keccak256("DEV_FUND_ACCESSOR");
    bytes32 public constant ENTROPY_ACCESSOR = keccak256("ENTROPY_ACCESSOR");
    bytes32 public constant PROTOCOL_MAINTAINER = keccak256("PROTOCOL_MAINTAINER");
    bytes32 public constant NUKE_FUND_ACCESSOR = keccak256("NUKE_FUND_ACCESSOR");
}

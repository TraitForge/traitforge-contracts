// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

library Roles {
    bytes32 public constant AIRDROP_ACCESSOR = keccak256("AIRDROP_ACCESSOR");
    bytes32 public constant DAOFUND_ACCESSOR = keccak256("DAOFUND_ACCESSOR");
    bytes32 public constant DEVFUND_ACCESSOR = keccak256("DEVFUND_ACCESSOR");
    bytes32 public constant ENTROPY_ACCESSOR = keccak256("ENTROPY_ACCESSOR");
    bytes32 public constant PROTOCOL_MAINTAINER = keccak256("PROTOCOL_MAINTAINER");
}

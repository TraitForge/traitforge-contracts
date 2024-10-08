// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

library Roles {
    // keccak256("AIRDROP_ACCESSOR") = 0x12a908b2cba1a015c528e378ff2e86bffc8be37d2def9c75c22ca89d6cc368ee
    bytes32 public constant AIRDROP_ACCESSOR = keccak256("AIRDROP_ACCESSOR");

    // keccak256("DAO_FUND_ACCESSOR") = 0x574aeecb7d7c7ccc071afb958bd8e81063287e9f574301a7ba2caafd4967c48d
    bytes32 public constant DAO_FUND_ACCESSOR = keccak256("DAO_FUND_ACCESSOR");

    // keccak256("DEV_FUND_ACCESSOR") = 0xa49bfefdfe87a8a34837d023db66628b615dd0344cc92d7feada291ae122d0e9
    bytes32 public constant DEV_FUND_ACCESSOR = keccak256("DEV_FUND_ACCESSOR");

    // keccak256("ENTROPY_ACCESSOR") = 0xb209b7f8ff6851be0ae7c043cc14fc21c75535142ed26d70dda8704da6e4eae6
    bytes32 public constant ENTROPY_ACCESSOR = keccak256("ENTROPY_ACCESSOR");

    // keccak256("PROTOCOL_MAINTAINER") = 0xc30f007ba88184a2af73fb442cfac292aa54837e5929d0d24188903703ab54b8
    bytes32 public constant PROTOCOL_MAINTAINER = keccak256("PROTOCOL_MAINTAINER");

    //keccak256("NUKE_FUND_ACCESSOR") = 0xe5f0a35a3e35af422c1c7ab250c429955f7c0b4fe424ff55bfb7af43067ab779
    bytes32 public constant NUKE_FUND_ACCESSOR = keccak256("NUKE_FUND_ACCESSOR");
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.23;

import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";

import { Roles } from "../libraries/Roles.sol";

/// @title AccessController
/// @notice Contract the handle access right for the protocol.
/// @dev The msg.sender should be different from the defaultAdmin and protocolMaintainer as after deployment msg.sender
/// roles should be revoked.
contract AccessController is AccessControl {
    constructor(address _defaultAdmin, address _protocolMaintainer) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(Roles.PROTOCOL_MAINTAINER, msg.sender);

        _grantRole(DEFAULT_ADMIN_ROLE, _defaultAdmin);
        _grantRole(Roles.PROTOCOL_MAINTAINER, _protocolMaintainer);
    }
}

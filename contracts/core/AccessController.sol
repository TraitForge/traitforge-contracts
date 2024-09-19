// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.23;

import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";

import { Roles } from "../libraries/Roles.sol";

/// @title AccessController
/// @notice Contract the handle access right for the protocol.
contract AccessController is AccessControl {
    constructor(address _protocolMaintainer) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(Roles.PROTOCOL_MAINTAINER, _protocolMaintainer);
    }
}

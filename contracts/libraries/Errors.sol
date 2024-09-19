// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.23;

/// @title Errors
/// @notice Library containing all generics custom errors the protocol may revert with.
library Errors {
    /// @notice Thrown when `msg.sender` has not MAINTAINER_ROLE.
    error CallerNotProtocolMaintainer(address caller);

    /// @notice Thrown when `msg.sender` has not USER_CENTRALIZED_ROLE.
    error CallerNotAirdropAccessor(address caller);

    /// @notice Thrown when `msg.sender` has not CUSTOMER_SERVICE_ROLE.
    error CallerNotDaoFundAccessor(address caller);

    /// @notice Thrown when `msg.sender` has not VALIDATOR_ROLE.
    error CallerNotDevFundAccessor(address caller);

    /// @notice Thrown when `msg.sender` is not the user or has not CUSTOMER_SERVICE_ROLE.
    error CallerNotEntropyAccessor(address caller);

    /// @notice Thrown when address is equal to address(0).
    error AddressCantBeZero();
}

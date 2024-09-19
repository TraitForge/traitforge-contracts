// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { AddressProvider } from "./AddressProvider.sol";
import { Errors } from "../libraries/Errors.sol";
import { Roles } from "../libraries/Roles.sol";
import { IAddressProvider } from "../interfaces/IAddressProvider.sol";

abstract contract AddressProviderResolver {
    /// @notice The addressProvider contract
    IAddressProvider internal _addressProvider;

    /// @notice Check that the caller has the PROTOCOL_MAINTAINER
    modifier onlyProtocolMaintainer() {
        if (!_addressProvider.getAccessController().hasRole(Roles.PROTOCOL_MAINTAINER, msg.sender)) {
            revert Errors.CallerNotProtocolMaintainer(msg.sender);
        }
        _;
    }

    /// @notice Check that the caller has the AIRDROP_ACCESSOR
    modifier onlyAirdropAccessor() {
        if (!_addressProvider.getAccessController().hasRole(Roles.AIRDROP_ACCESSOR, msg.sender)) {
            revert Errors.CallerNotAirdropAccessor(msg.sender);
        }
        _;
    }

    /// @notice Check that the caller has the DAOFUND_ACCESSOR
    modifier onlyDaoFundAccessor() {
        if (!_addressProvider.getAccessController().hasRole(Roles.DAOFUND_ACCESSOR, msg.sender)) {
            revert Errors.CallerNotDaoFundAccessor(msg.sender);
        }
        _;
    }

    /// @notice Check that the caller has the DAOFUND_ACCESSOR
    modifier onlyDevFundAccessor() {
        if (!_addressProvider.getAccessController().hasRole(Roles.DEVFUND_ACCESSOR, msg.sender)) {
            revert Errors.CallerNotDevFundAccessor(msg.sender);
        }
        _;
    }

    /// @notice Check that the caller has the ENTROPY_ACCESSOR
    modifier onlyEntropyAccessor() {
        if (!_addressProvider.getAccessController().hasRole(Roles.ENTROPY_ACCESSOR, msg.sender)) {
            revert Errors.CallerNotEntropyAccessor(msg.sender);
        }
        _;
    }

    constructor(address addressProvider) {
        if (addressProvider == address(0)) revert Errors.AddressCantBeZero();
        _addressProvider = IAddressProvider(addressProvider);
    }
}

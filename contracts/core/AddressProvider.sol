// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { IAddressProvider } from "../interfaces/IAddressProvider.sol";
import { IAccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { Roles } from "../libraries/Roles.sol";
import { Errors } from "../libraries/Errors.sol";

contract AddressProvider is IAddressProvider {
    IAccessControl private _accessController;
    address private _airdrop;
    address private _daoFund;
    address private _devFund;
    address private _entityForging;
    address private _entityTrading;
    address private _entropyGenerator;
    address private _nukeFund;
    address private _trait;
    address private _traitForgeNft;

    constructor(address accessControllerAddress) {
        if (accessControllerAddress == address(0)) revert Errors.AddressCantBeZero();
        _accessController = IAccessControl(accessControllerAddress);
    }

    /// @notice Check that the caller has the PROTOCOL_MAINTAINER
    modifier onlyProtocolMaintainer() {
        if (!_accessController.hasRole(Roles.PROTOCOL_MAINTAINER, msg.sender)) {
            revert Errors.CallerNotProtocolMaintainer(msg.sender);
        }
        _;
    }

    function getAccessController() external view returns (IAccessControl) {
        return _accessController;
    }

    /// @inheritdoc IAddressProvider
    function getAirdrop() external view returns (address) {
        return _airdrop;
    }

    /// @inheritdoc IAddressProvider
    function getDAOFund() external view returns (address) {
        return _daoFund;
    }

    /// @inheritdoc IAddressProvider
    function getDevFund() external view returns (address) {
        return _devFund;
    }

    /// @inheritdoc IAddressProvider
    function getEntityForging() external view returns (address) {
        return _entityForging;
    }

    /// @inheritdoc IAddressProvider
    function getEntityTrading() external view returns (address) {
        return _entityTrading;
    }

    /// @inheritdoc IAddressProvider
    function getEntropyGenerator() external view returns (address) {
        return _entropyGenerator;
    }

    /// @inheritdoc IAddressProvider
    function getNukeFund() external view returns (address) {
        return _nukeFund;
    }

    /// @inheritdoc IAddressProvider
    function getTrait() external view returns (address) {
        return _trait;
    }

    /// @inheritdoc IAddressProvider
    function getTraitForgeNft() external view returns (address) {
        return _traitForgeNft;
    }

    ///////////////////  Setters  ////////////////////

    function setAirdrop(address _newAddress) external onlyProtocolMaintainer {
        if (_newAddress == address(0)) revert Errors.AddressCantBeZero();
        _airdrop = _newAddress;
    }

    function setDAOFund(address _newAddress) external onlyProtocolMaintainer {
        if (_newAddress == address(0)) revert Errors.AddressCantBeZero();
        _daoFund = _newAddress;
    }

    function setDevFund(address _newAddress) external onlyProtocolMaintainer {
        if (_newAddress == address(0)) revert Errors.AddressCantBeZero();
        _devFund = _newAddress;
    }

    function setEntityForging(address _newAddress) external onlyProtocolMaintainer {
        if (_newAddress == address(0)) revert Errors.AddressCantBeZero();
        _entityForging = _newAddress;
    }

    function setEntityTrading(address _newAddress) external onlyProtocolMaintainer {
        if (_newAddress == address(0)) revert Errors.AddressCantBeZero();
        _entityTrading = _newAddress;
    }

    function setEntropyGenerator(address _newAddress) external onlyProtocolMaintainer {
        if (_newAddress == address(0)) revert Errors.AddressCantBeZero();
        _entropyGenerator = _newAddress;
    }

    function setNukeFund(address _newAddress) external onlyProtocolMaintainer {
        if (_newAddress == address(0)) revert Errors.AddressCantBeZero();
        _nukeFund = _newAddress;
    }

    function setTrait(address _newAddress) external onlyProtocolMaintainer {
        if (_newAddress == address(0)) revert Errors.AddressCantBeZero();
        _trait = _newAddress;
    }

    function setTraitForgeNft(address _newAddress) external onlyProtocolMaintainer {
        if (_newAddress == address(0)) revert Errors.AddressCantBeZero();
        _traitForgeNft = _newAddress;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";

import { DevFund } from "contracts/DevFund.sol";

contract DeployDevFund is BaseScript {
    function run() public virtual initConfig broadcast {
        if (devFund != address(0)) {
            revert AlreadyDeployed();
        }

        if (ethCollector == address(0)) {
            revert AddressIsZero();
        }
        
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }
        DevFund df = _deployDevFund();
        AddressProvider ap = AddressProvider(addressProvider);
        ap.setDevFund(address(df));}

    function _deployDevFund() internal returns (DevFund) {
        return new DevFund(addressProvider, ethCollector);
    }
}

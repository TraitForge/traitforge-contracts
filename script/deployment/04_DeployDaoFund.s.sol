// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";

import { DAOFund } from "contracts/DAOFund.sol";

contract DeployDaoFund is BaseScript {
    function run() public virtual initConfig broadcast {
        if (daoFund != address(0)) {
            revert AlreadyDeployed();
        }

        if (uniswapRouter == address(0)) {
            revert AddressIsZero();
        }

        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }
        DAOFund df = _deploydaoFund();
        AddressProvider ap = AddressProvider(addressProvider);
        ap.setDAOFund(address(df));
    }

    function _deploydaoFund() internal returns (DAOFund) {
        return new DAOFund(uniswapRouter, addressProvider);
    }
}

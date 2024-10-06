// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { console } from "@forge-std/console.sol";

import { DAOFund } from "contracts/DAOFund.sol";

contract DeployDaoFund is BaseScript {
    function run() public virtual initConfig broadcast {
        if (uniswapRouter == address(0)) {
            revert AddressIsZero();
        }

        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }
        address newDaoFundAddress = _deployDaoFund();
        console.log("DAOFund deployed at address: ", address(newDaoFundAddress));
    }

    function _deployDaoFund() internal returns (address) {
        return address(new DAOFund(uniswapRouter, addressProvider));
    }
}

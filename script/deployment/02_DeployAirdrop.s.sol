// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";

import { Airdrop } from "contracts/Airdrop.sol";

contract DeployAirdrop is BaseScript {
    function run() public virtual initConfig broadcast {
        if (airdrop != address(0)) {
            revert AlreadyDeployed();
        }
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }
        Airdrop ad = _deployAirdrop();
        AddressProvider ap = AddressProvider(addressProvider);
        ap.setAirdrop(address(ad));
    }

    function _deployAirdrop() internal returns (Airdrop) {
        return new Airdrop(addressProvider);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { BaseScript } from "../Base.s.sol";
import { AddressProvider } from "contracts/core/AddressProvider.sol";
import { Roles } from "contracts/libraries/Roles.sol";

contract UpdateAddressProvider is BaseScript {
    function run() public virtual initConfig broadcast {
        if (addressProvider == address(0)) {
            revert AddressProviderAddressIsZero();
        }

        AddressProvider ap = AddressProvider(addressProvider);
        ap.setAirdrop(airdrop);
        // ap.setDAOFund(daoFund);
        ap.setDevFund(devFund);
        ap.setEntityForging(entityForging);
        ap.setEntityTrading(entityTrading);
        ap.setEntropyGenerator(entropyGenerator);
        ap.setNukeFund(nukeFund);
        ap.setTrait(trait);
        ap.setTraitForgeNft(traitForgeNft);
    }
}

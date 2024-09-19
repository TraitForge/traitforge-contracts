// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "@forge-std/Test.sol";

import { AddressProvider } from "contracts/core/AddressProvider.sol";
import { AccessController } from "contracts/core/AccessController.sol";
import { Airdrop } from "contracts/Airdrop.sol";
import { DAOFund } from "contracts/DAOFund.sol";
import { DevFund } from "contracts/DevFund.sol";
import { EntityForging } from "contracts/EntityForging.sol";
import { EntityTrading } from "contracts/EntityTrading.sol";
import { EntropyGenerator } from "contracts/EntropyGenerator.sol";
import { NukeFund } from "contracts/NukeFund.sol";
import { Trait } from "contracts/Trait.sol";
import { TraitForgeNft } from "contracts/TraitForgeNft.sol";
import { Roles } from "contracts/libraries/Roles.sol";

contract Deploys is Test {
    address internal _defaultAdmin = makeAddr("defaultAdmin");
    address internal _protocolMaintainer = makeAddr("protocolMaintainer");
    address internal _traitMinter = makeAddr("traitMinter");
    address internal _randomUser = makeAddr("_randomUser");

    AddressProvider internal _addressProvider;
    Airdrop internal _airdrop;
    DAOFund internal _daoFund;
    DevFund internal _devFund;
    EntityForging internal _entityForging;
    EntityTrading internal _entityTrading;
    EntropyGenerator internal _entropyGenerator;
    NukeFund internal _nukeFund;
    Trait internal _trait;
    TraitForgeNft internal _traitForgeNft;
    AccessController internal _accessController;

    function setUp() public virtual {
        _deployAddressProvider();
        _deployAirdrop();
        _deployDAOFund();
        _deployDevFund();
        _deployEntityForging();
        _deployEntityTrading();
        _deployEntropyGenerator();
        _deployNukeFund();
        _deployTrait();
        _deployTraitForgeNft();
    }

    function _deployAddressProvider() internal {
        _accessController = _deployAccessController();
        AddressProvider ad = new AddressProvider(address(_accessController));
        _addressProvider = ad;
    }

    function _deployAirdrop() private {
        _airdrop = new Airdrop(address(_addressProvider));
        vm.prank(_protocolMaintainer);
        _addressProvider.setAirdrop(address(_airdrop));
    }

    function _deployDAOFund() private {
        address router = makeAddr("router");
        _daoFund = new DAOFund(router, address(_addressProvider));
        vm.prank(_protocolMaintainer);
        _addressProvider.setDAOFund(address(_daoFund));
    }

    function _deployDevFund() private {
        address ethCollector = makeAddr("ethCollector");
        _devFund = new DevFund(address(_addressProvider), ethCollector);
        vm.prank(_protocolMaintainer);
        _addressProvider.setDevFund(address(_devFund));
    }

    function _deployEntityForging() private {
        _entityForging = new EntityForging(address(_addressProvider));
        vm.prank(_protocolMaintainer);
        _addressProvider.setEntityForging(address(_entityForging));
    }

    function _deployEntityTrading() private {
        _entityTrading = new EntityTrading(address(_addressProvider));
        vm.prank(_protocolMaintainer);
        _addressProvider.setEntityTrading(address(_entityTrading));
    }

    function _deployEntropyGenerator() private {
        _entropyGenerator = new EntropyGenerator(address(_addressProvider));
        vm.prank(_protocolMaintainer);
        _addressProvider.setEntropyGenerator(address(_entropyGenerator));
    }

    function _deployNukeFund() private {
        address ethCollector = makeAddr("ethCollector");
        _nukeFund = new NukeFund(address(_addressProvider), ethCollector);
        vm.prank(_protocolMaintainer);
        _addressProvider.setNukeFund(address(_nukeFund));
    }

    function _deployTrait() private {
        vm.prank(_traitMinter);
        _trait = new Trait("TraitForge", "TF", 18, 1_000_000_000 ether);
        vm.prank(_protocolMaintainer);
        _addressProvider.setTrait(address(_trait));
    }

    function _deployTraitForgeNft() private {
        _traitForgeNft = new TraitForgeNft(address(_addressProvider));
        vm.prank(_protocolMaintainer);
        _addressProvider.setTraitForgeNft(address(_traitForgeNft));
        vm.prank(_defaultAdmin);
        _accessController.grantRole(Roles.AIRDROP_ACCESSOR, address(_traitForgeNft));
    }

    function _deployAccessController() private returns (AccessController) {
        vm.prank(_defaultAdmin);
        return new AccessController(_protocolMaintainer);
    }
}

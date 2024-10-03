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
    address internal _partner = makeAddr("_partner");

    mapping(uint256 tokenId => bool) isTokenForger;
    mapping(uint256 tokenId => bool) isTokenMerger;
    mapping(uint256 tokenId => bool) isTokenNoPotentialForger;
    mapping(uint256 tokenId => bool) isTokenNoPotentialMerger;

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
        address[] memory partners = new address[](1);
        partners[0] = _partner;
        address liquidityPoolAddress = makeAddr("liquidityPoolAddress");
        address devAddress = makeAddr("devAddress");
        vm.startPrank(_protocolMaintainer);
        _addressProvider.setAirdrop(address(_airdrop));
        _airdrop.setPartnerAddresses(partners);
        _airdrop.setLiquidityPoolAddress(liquidityPoolAddress);
        _airdrop.setDevAddress(devAddress);
        vm.stopPrank();
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
        _traitForgeNft = new TraitForgeNft(address(_addressProvider), bytes32(0));
        vm.prank(_protocolMaintainer);
        _addressProvider.setTraitForgeNft(address(_traitForgeNft));
        vm.startPrank(_defaultAdmin);
        _accessController.grantRole(Roles.AIRDROP_ACCESSOR, address(_traitForgeNft));
        _accessController.grantRole(Roles.ENTROPY_ACCESSOR, address(_traitForgeNft));
        vm.stopPrank();
    }

    function _deployAccessController() private returns (AccessController) {
        return new AccessController(_defaultAdmin, _protocolMaintainer);
    }

    ///////////////////////////////////// Helpers /////////////////////////////////////

    function _skipWhitelistTime() internal {
        uint256 _endWhitheListTimestamp = _traitForgeNft.whitelistEndTime();
        skip(_endWhitheListTimestamp + 1);
    }

    function _mintTraitForgeNft(address _user, uint256 _amount) internal {
        _skipWhitelistTime();
        bytes32[] memory proofs = new bytes32[](0);
        for (uint256 i = 0; i < _amount; i++) {
            uint256 price = _traitForgeNft.calculateMintPrice();
            vm.startPrank(_user);
            uint256 tokenId = _traitForgeNft.mintToken{ value: price }(proofs);
            if (_traitForgeNft.isForger(tokenId)) {
                if ((_traitForgeNft.getTokenEntropy(tokenId) / 10) % 10 > 0) {
                    isTokenForger[tokenId] = true;
                } else {
                    isTokenNoPotentialForger[tokenId] = true;
                }
            } else {
                if ((_traitForgeNft.getTokenEntropy(tokenId) / 10) % 10 > 0) {
                    isTokenMerger[tokenId] = true;
                } else {
                    isTokenNoPotentialMerger[tokenId] = true;
                }
            }
            vm.stopPrank();
        }
    }

    function _getTheNthForgerId(
        uint256 startIndex,
        uint256 endIndex,
        uint256 n
    )
        internal
        view
        returns (uint256 theNthTokenId)
    {
        uint256 count = 0;
        for (uint256 i = startIndex; i < endIndex; i++) {
            if (isTokenForger[i + 1]) {
                count++;
                if (count == n) {
                    theNthTokenId = i + 1;
                }
            }
        }
    }

    function _getTheNthMergerId(
        uint256 startIndex,
        uint256 endIndex,
        uint256 n
    )
        internal
        view
        returns (uint256 theNthTokenId)
    {
        uint256 count = 0;
        for (uint256 i = startIndex; i < endIndex; i++) {
            if (isTokenMerger[i + 1]) {
                count++;
                if (count == n) {
                    theNthTokenId = i + 1;
                }
            }
        }
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { IAccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";

/// @title IAddressProvider
/// @notice Contract that handle the address of the different contracts.
interface IAddressProvider {
    //----------------------------------------
    // Events
    //----------------------------------------
    event AirdropUpdated(address newAirdropAddress);

    event DAOFundUpdated(address newDAOFundAddress);

    event DevFundUpdated(address newDevFundAddress);

    event EntityForgingUpdated(address newEntityForgingAddress);

    event EntityTradingUpdated(address newEntityTradingAddress);

    event EntropyGeneratorUpdated(address newEntropyGeneratorAddress);

    event NukeFundUpdated(address newNukeFundAddress);

    event TraitUpdated(address newTraitAddress);

    event TraitForgeNftUpdated(address newTraitForgeNftAddress);

    //----------------------------------------
    // Functions
    //----------------------------------------

    function getAccessController() external view returns (IAccessControl);

    /// @notice Get the instance of the Airdrop contract.
    /// @return The address of the Airdrop contract.
    function getAirdrop() external view returns (address);

    /// @notice Get the address of the DAOFund contract.
    /// @return The address of the DAOFund contract.
    function getDAOFund() external view returns (address);

    /// @notice Get the address of the DevFund contract.
    /// @return The address of the DevFund contract.
    function getDevFund() external view returns (address);

    /// @notice Get the address of the EntityForging contract.
    /// @return The address of the EntityForging contract.
    function getEntityForging() external view returns (address);

    /// @notice Get the address of the EntityTrading contract.
    /// @return The address of the EntityTrading contract.
    function getEntityTrading() external view returns (address);

    /// @notice Get the address of the EntropyGenerator contract.
    /// @return The address of the EntropyGenerator contract.
    function getEntropyGenerator() external view returns (address);

    /// @notice Get the address of the NukeFund contract.
    /// @return The address of the NukeFund contract.
    function getNukeFund() external view returns (address);

    /// @notice Get the address of the Trait contract.
    /// @return The address of the Trait contract.
    function getTrait() external view returns (address);

    /// @notice Get the address TraitForgeNft contract.
    /// @return The address of the TraitForgeNft contrct.
    function getTraitForgeNft() external view returns (address);
}

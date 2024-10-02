// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Pausable } from "@openzeppelin/contracts/security/Pausable.sol";
import { IEntropyGenerator } from "./interfaces/IEntropyGenerator.sol";
import { AddressProviderResolver } from "./core/AddressProviderResolver.sol";

// EntropyGenerator is a contract designed to generate pseudo-random values for use in other contracts
contract EntropyGenerator is IEntropyGenerator, AddressProviderResolver, Pausable {
    uint256[833] private entropySlots; // Array to store entropy values
    uint256 private lastInitializedIndex = 0; // Indexes to keep track of the initialization and usage of entropy values
    uint256 public currentSlotIndex = 0;
    uint256 public currentNumberIndex = 0;

    // Constants to define the limits for slots and numbers within those slots
    uint256 private maxSlotIndex = 833;
    uint256 private maxNumberIndex = 12;
    uint256 public slotIndexSelectionPoint;
    uint256 public numberIndexSelectionPoint;

    constructor(address addressProvider) AddressProviderResolver(addressProvider) {
        _writeEntropyBatch(); // M05
        _initializeAlphaIndices();
    }

    function nextEntropy() public onlyEntropyAccessor returns (uint256) {
        require(currentSlotIndex < maxSlotIndex, "Max slot index reached."); // M01
        uint256 entropy;
        do {
            entropy = getEntropy(currentSlotIndex, currentNumberIndex);
            if (currentNumberIndex >= maxNumberIndex - 1) {
                currentNumberIndex = 0;
                if (currentSlotIndex >= maxSlotIndex - 1) {
                    currentSlotIndex = 0;
                } else {
                    currentSlotIndex++;
                }
            } else {
                currentNumberIndex++;
            }
        } while (entropy == 0 || entropy < 100_000 || entropy > 999_999); // Ensure it's a 6-digit number and not 0
        emit EntropyRetrieved(entropy);
        return entropy;
    }

    // Select index points for 999999, triggered each generation increment
    function initializeAlphaIndices() public onlyEntropyAccessor {
        _initializeAlphaIndices();
    }

    // Public function to expose entropy calculation for a given slot and number index
    function getPublicEntropy(uint256 slotIndex, uint256 numberIndex) public view returns (uint256) {
        return getEntropy(slotIndex, numberIndex);
    }

    function getEntropySlot(uint256 index) external view returns (uint256) {
        require(index < 833, "Index out of bounds");
        return entropySlots[index];
    }

    // Function to get the last initialized index for debugging or informational purposes
    function getLastInitializedIndex() public view returns (uint256) {
        return lastInitializedIndex;
    }

    function getInbredEntropy() public view returns (uint256) {
        uint256 entropy = 1; // Start with 1 to ensure the first digit is 1
        for (uint256 i = 0; i < 5; i++) {
            uint256 bit = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, i))) % 3;
            entropy = entropy * 10 + bit;
        }
        return entropy;
    }

    // Private function to calculate the entropy value based on slot and number index
    function getEntropy(uint256 slotIndex, uint256 numberIndex) private view returns (uint256) {
        require(slotIndex < maxSlotIndex, "Slot index out of bounds.");

        if (slotIndex == slotIndexSelectionPoint && numberIndex == numberIndexSelectionPoint) {
            return 999_999;
        }

        uint256 position = numberIndex * 6; // Calculate the position for slicing the entropy value
        require(position <= 66, "Position calculation error");

        uint256 slotValue = entropySlots[slotIndex]; // Slice the required part of the entropy value
        uint256 entropy = (slotValue / (10 ** (66 - position))) % 1_000_000; // Adjust the entropy value based on the
            // number of digits
        uint256 paddedEntropy = entropy * (10 ** (6 - numberOfDigits(entropy)));

        return paddedEntropy; // Return the calculated entropy value
    }

    // Utility function to calculate the number of digits in a number
    function numberOfDigits(uint256 number) private pure returns (uint256) {
        uint256 digits = 0;
        while (number != 0) {
            number /= 10;
            digits++;
        }
        return digits;
    }

    // Functions to initialize entropy values in batches to spread gas cost over multiple transactions
    function _writeEntropyBatch() private {
        uint256 endIndex = 833; // We want to initialize all 770 slots
        for (uint256 i = lastInitializedIndex; i < endIndex; i++) {
            uint256 pseudoRandomValue =
                uint256(keccak256(abi.encodePacked(block.number, block.timestamp, i))) % uint256(10) ** 77; // generate a
                // pseudo-random value using block number and index
            entropySlots[i] = pseudoRandomValue; // store the value in the slots array
        }
        lastInitializedIndex = endIndex; // Update the index to indicate initialization is complete
    }

    function _initializeAlphaIndices() private {
        uint256 hashValue = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));

        uint256 slotIndexSelection = (hashValue % 258) + 612;
        uint256 numberIndexSelection = hashValue % 12;

        slotIndexSelectionPoint = slotIndexSelection;
        numberIndexSelectionPoint = numberIndexSelection;
    }
}

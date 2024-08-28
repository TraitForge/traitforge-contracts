/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Interface, type ContractRunner } from "ethers";
import type {
  IEntropyGenerator,
  IEntropyGeneratorInterface,
} from "../../../contracts/EntropyGenerator/IEntropyGenerator";

const _abi = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "allowedCaller",
        type: "address",
      },
    ],
    name: "AllowedCallerUpdated",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint256",
        name: "entropy",
        type: "uint256",
      },
    ],
    name: "EntropyRetrieved",
    type: "event",
  },
  {
    inputs: [],
    name: "getAllowedCaller",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getLastInitializedIndex",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getNextEntropy",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "slotIndex",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "numberIndex",
        type: "uint256",
      },
    ],
    name: "getPublicEntropy",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "initializeAlphaIndices",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_allowedCaller",
        type: "address",
      },
    ],
    name: "setAllowedCaller",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "writeEntropyBatch",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export class IEntropyGenerator__factory {
  static readonly abi = _abi;
  static createInterface(): IEntropyGeneratorInterface {
    return new Interface(_abi) as IEntropyGeneratorInterface;
  }
  static connect(
    address: string,
    runner?: ContractRunner | null
  ): IEntropyGenerator {
    return new Contract(address, _abi, runner) as unknown as IEntropyGenerator;
  }
}

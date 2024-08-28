/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumberish,
  BytesLike,
  FunctionFragment,
  Result,
  Interface,
  EventFragment,
  AddressLike,
  ContractRunner,
  ContractMethod,
  Listener,
} from "ethers";
import type {
  TypedContractEvent,
  TypedDeferredTopicFilter,
  TypedEventLog,
  TypedLogDescription,
  TypedListener,
  TypedContractMethod,
} from "../../common";

export interface ITraitForgeNftInterface extends Interface {
  getFunction(
    nameOrSignature:
      | "approve"
      | "balanceOf"
      | "burn"
      | "calculateMintPrice"
      | "forge"
      | "getApproved"
      | "getEntropiesForTokens"
      | "getTokenCreationTimestamp"
      | "getTokenEntropy"
      | "getTokenGeneration"
      | "getTokenLastTransferredTimestamp"
      | "isApprovedForAll"
      | "isApprovedOrOwner"
      | "isForger"
      | "mintToken"
      | "mintWithBudget"
      | "ownerOf"
      | "safeTransferFrom(address,address,uint256)"
      | "safeTransferFrom(address,address,uint256,bytes)"
      | "setAirdropContract"
      | "setApprovalForAll"
      | "setEntityForgingContract"
      | "setEntropyGenerator"
      | "setNukeFundContract"
      | "setPriceIncrement"
      | "setPriceIncrementByGen"
      | "setStartPrice"
      | "startAirdrop"
      | "supportsInterface"
      | "tokenByIndex"
      | "tokenOfOwnerByIndex"
      | "totalSupply"
      | "transferFrom"
  ): FunctionFragment;

  getEvent(
    nameOrSignatureOrTopic:
      | "Approval"
      | "ApprovalForAll"
      | "FundsDistributedToNukeFund"
      | "GenerationIncremented"
      | "Minted"
      | "NewEntityMinted"
      | "NukeFundContractUpdated"
      | "Transfer"
  ): EventFragment;

  encodeFunctionData(
    functionFragment: "approve",
    values: [AddressLike, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "balanceOf",
    values: [AddressLike]
  ): string;
  encodeFunctionData(functionFragment: "burn", values: [BigNumberish]): string;
  encodeFunctionData(
    functionFragment: "calculateMintPrice",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "forge",
    values: [AddressLike, BigNumberish, BigNumberish, string]
  ): string;
  encodeFunctionData(
    functionFragment: "getApproved",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "getEntropiesForTokens",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "getTokenCreationTimestamp",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "getTokenEntropy",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "getTokenGeneration",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "getTokenLastTransferredTimestamp",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "isApprovedForAll",
    values: [AddressLike, AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "isApprovedOrOwner",
    values: [AddressLike, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "isForger",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "mintToken",
    values: [BytesLike[]]
  ): string;
  encodeFunctionData(
    functionFragment: "mintWithBudget",
    values: [BytesLike[]]
  ): string;
  encodeFunctionData(
    functionFragment: "ownerOf",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "safeTransferFrom(address,address,uint256)",
    values: [AddressLike, AddressLike, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "safeTransferFrom(address,address,uint256,bytes)",
    values: [AddressLike, AddressLike, BigNumberish, BytesLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setAirdropContract",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setApprovalForAll",
    values: [AddressLike, boolean]
  ): string;
  encodeFunctionData(
    functionFragment: "setEntityForgingContract",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setEntropyGenerator",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setNukeFundContract",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setPriceIncrement",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setPriceIncrementByGen",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setStartPrice",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "startAirdrop",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "supportsInterface",
    values: [BytesLike]
  ): string;
  encodeFunctionData(
    functionFragment: "tokenByIndex",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "tokenOfOwnerByIndex",
    values: [AddressLike, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "totalSupply",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "transferFrom",
    values: [AddressLike, AddressLike, BigNumberish]
  ): string;

  decodeFunctionResult(functionFragment: "approve", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "balanceOf", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "burn", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "calculateMintPrice",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "forge", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "getApproved",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getEntropiesForTokens",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getTokenCreationTimestamp",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getTokenEntropy",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getTokenGeneration",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getTokenLastTransferredTimestamp",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "isApprovedForAll",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "isApprovedOrOwner",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "isForger", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "mintToken", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "mintWithBudget",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "ownerOf", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "safeTransferFrom(address,address,uint256)",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "safeTransferFrom(address,address,uint256,bytes)",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setAirdropContract",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setApprovalForAll",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setEntityForgingContract",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setEntropyGenerator",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setNukeFundContract",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setPriceIncrement",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setPriceIncrementByGen",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setStartPrice",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "startAirdrop",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "supportsInterface",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "tokenByIndex",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "tokenOfOwnerByIndex",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "totalSupply",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "transferFrom",
    data: BytesLike
  ): Result;
}

export namespace ApprovalEvent {
  export type InputTuple = [
    owner: AddressLike,
    approved: AddressLike,
    tokenId: BigNumberish
  ];
  export type OutputTuple = [owner: string, approved: string, tokenId: bigint];
  export interface OutputObject {
    owner: string;
    approved: string;
    tokenId: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace ApprovalForAllEvent {
  export type InputTuple = [
    owner: AddressLike,
    operator: AddressLike,
    approved: boolean
  ];
  export type OutputTuple = [
    owner: string,
    operator: string,
    approved: boolean
  ];
  export interface OutputObject {
    owner: string;
    operator: string;
    approved: boolean;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace FundsDistributedToNukeFundEvent {
  export type InputTuple = [to: AddressLike, amount: BigNumberish];
  export type OutputTuple = [to: string, amount: bigint];
  export interface OutputObject {
    to: string;
    amount: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace GenerationIncrementedEvent {
  export type InputTuple = [newGeneration: BigNumberish];
  export type OutputTuple = [newGeneration: bigint];
  export interface OutputObject {
    newGeneration: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace MintedEvent {
  export type InputTuple = [
    minter: AddressLike,
    itemId: BigNumberish,
    generation: BigNumberish,
    entropyValue: BigNumberish,
    mintPrice: BigNumberish
  ];
  export type OutputTuple = [
    minter: string,
    itemId: bigint,
    generation: bigint,
    entropyValue: bigint,
    mintPrice: bigint
  ];
  export interface OutputObject {
    minter: string;
    itemId: bigint;
    generation: bigint;
    entropyValue: bigint;
    mintPrice: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace NewEntityMintedEvent {
  export type InputTuple = [
    owner: AddressLike,
    tokenId: BigNumberish,
    generation: BigNumberish,
    entropy: BigNumberish
  ];
  export type OutputTuple = [
    owner: string,
    tokenId: bigint,
    generation: bigint,
    entropy: bigint
  ];
  export interface OutputObject {
    owner: string;
    tokenId: bigint;
    generation: bigint;
    entropy: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace NukeFundContractUpdatedEvent {
  export type InputTuple = [nukeFundAddress: AddressLike];
  export type OutputTuple = [nukeFundAddress: string];
  export interface OutputObject {
    nukeFundAddress: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace TransferEvent {
  export type InputTuple = [
    from: AddressLike,
    to: AddressLike,
    tokenId: BigNumberish
  ];
  export type OutputTuple = [from: string, to: string, tokenId: bigint];
  export interface OutputObject {
    from: string;
    to: string;
    tokenId: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export interface ITraitForgeNft extends BaseContract {
  connect(runner?: ContractRunner | null): ITraitForgeNft;
  waitForDeployment(): Promise<this>;

  interface: ITraitForgeNftInterface;

  queryFilter<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEventLog<TCEvent>>>;
  queryFilter<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEventLog<TCEvent>>>;

  on<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    listener: TypedListener<TCEvent>
  ): Promise<this>;
  on<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    listener: TypedListener<TCEvent>
  ): Promise<this>;

  once<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    listener: TypedListener<TCEvent>
  ): Promise<this>;
  once<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    listener: TypedListener<TCEvent>
  ): Promise<this>;

  listeners<TCEvent extends TypedContractEvent>(
    event: TCEvent
  ): Promise<Array<TypedListener<TCEvent>>>;
  listeners(eventName?: string): Promise<Array<Listener>>;
  removeAllListeners<TCEvent extends TypedContractEvent>(
    event?: TCEvent
  ): Promise<this>;

  approve: TypedContractMethod<
    [to: AddressLike, tokenId: BigNumberish],
    [void],
    "nonpayable"
  >;

  balanceOf: TypedContractMethod<[owner: AddressLike], [bigint], "view">;

  burn: TypedContractMethod<[tokenId: BigNumberish], [void], "nonpayable">;

  calculateMintPrice: TypedContractMethod<[], [bigint], "view">;

  forge: TypedContractMethod<
    [
      newOwner: AddressLike,
      parent1Id: BigNumberish,
      parent2Id: BigNumberish,
      baseTokenURI: string
    ],
    [bigint],
    "nonpayable"
  >;

  getApproved: TypedContractMethod<[tokenId: BigNumberish], [string], "view">;

  getEntropiesForTokens: TypedContractMethod<
    [forgerTokenId: BigNumberish, mergerTokenId: BigNumberish],
    [[bigint, bigint] & { forgerEntropy: bigint; mergerEntropy: bigint }],
    "view"
  >;

  getTokenCreationTimestamp: TypedContractMethod<
    [tokenId: BigNumberish],
    [bigint],
    "view"
  >;

  getTokenEntropy: TypedContractMethod<
    [tokenId: BigNumberish],
    [bigint],
    "view"
  >;

  getTokenGeneration: TypedContractMethod<
    [tokenId: BigNumberish],
    [bigint],
    "view"
  >;

  getTokenLastTransferredTimestamp: TypedContractMethod<
    [tokenId: BigNumberish],
    [bigint],
    "view"
  >;

  isApprovedForAll: TypedContractMethod<
    [owner: AddressLike, operator: AddressLike],
    [boolean],
    "view"
  >;

  isApprovedOrOwner: TypedContractMethod<
    [spender: AddressLike, tokenId: BigNumberish],
    [boolean],
    "view"
  >;

  isForger: TypedContractMethod<[tokenId: BigNumberish], [boolean], "view">;

  mintToken: TypedContractMethod<[proof: BytesLike[]], [void], "payable">;

  mintWithBudget: TypedContractMethod<[proof: BytesLike[]], [void], "payable">;

  ownerOf: TypedContractMethod<[tokenId: BigNumberish], [string], "view">;

  "safeTransferFrom(address,address,uint256)": TypedContractMethod<
    [from: AddressLike, to: AddressLike, tokenId: BigNumberish],
    [void],
    "nonpayable"
  >;

  "safeTransferFrom(address,address,uint256,bytes)": TypedContractMethod<
    [
      from: AddressLike,
      to: AddressLike,
      tokenId: BigNumberish,
      data: BytesLike
    ],
    [void],
    "nonpayable"
  >;

  setAirdropContract: TypedContractMethod<
    [_airdrop: AddressLike],
    [void],
    "nonpayable"
  >;

  setApprovalForAll: TypedContractMethod<
    [operator: AddressLike, approved: boolean],
    [void],
    "nonpayable"
  >;

  setEntityForgingContract: TypedContractMethod<
    [_entityForgingAddress: AddressLike],
    [void],
    "nonpayable"
  >;

  setEntropyGenerator: TypedContractMethod<
    [_entropyGeneratorAddress: AddressLike],
    [void],
    "nonpayable"
  >;

  setNukeFundContract: TypedContractMethod<
    [_nukeFundAddress: AddressLike],
    [void],
    "nonpayable"
  >;

  setPriceIncrement: TypedContractMethod<
    [_priceIncrement: BigNumberish],
    [void],
    "nonpayable"
  >;

  setPriceIncrementByGen: TypedContractMethod<
    [_priceIncrementByGen: BigNumberish],
    [void],
    "nonpayable"
  >;

  setStartPrice: TypedContractMethod<
    [_startPrice: BigNumberish],
    [void],
    "nonpayable"
  >;

  startAirdrop: TypedContractMethod<
    [amount: BigNumberish],
    [void],
    "nonpayable"
  >;

  supportsInterface: TypedContractMethod<
    [interfaceId: BytesLike],
    [boolean],
    "view"
  >;

  tokenByIndex: TypedContractMethod<[index: BigNumberish], [bigint], "view">;

  tokenOfOwnerByIndex: TypedContractMethod<
    [owner: AddressLike, index: BigNumberish],
    [bigint],
    "view"
  >;

  totalSupply: TypedContractMethod<[], [bigint], "view">;

  transferFrom: TypedContractMethod<
    [from: AddressLike, to: AddressLike, tokenId: BigNumberish],
    [void],
    "nonpayable"
  >;

  getFunction<T extends ContractMethod = ContractMethod>(
    key: string | FunctionFragment
  ): T;

  getFunction(
    nameOrSignature: "approve"
  ): TypedContractMethod<
    [to: AddressLike, tokenId: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "balanceOf"
  ): TypedContractMethod<[owner: AddressLike], [bigint], "view">;
  getFunction(
    nameOrSignature: "burn"
  ): TypedContractMethod<[tokenId: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "calculateMintPrice"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "forge"
  ): TypedContractMethod<
    [
      newOwner: AddressLike,
      parent1Id: BigNumberish,
      parent2Id: BigNumberish,
      baseTokenURI: string
    ],
    [bigint],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "getApproved"
  ): TypedContractMethod<[tokenId: BigNumberish], [string], "view">;
  getFunction(
    nameOrSignature: "getEntropiesForTokens"
  ): TypedContractMethod<
    [forgerTokenId: BigNumberish, mergerTokenId: BigNumberish],
    [[bigint, bigint] & { forgerEntropy: bigint; mergerEntropy: bigint }],
    "view"
  >;
  getFunction(
    nameOrSignature: "getTokenCreationTimestamp"
  ): TypedContractMethod<[tokenId: BigNumberish], [bigint], "view">;
  getFunction(
    nameOrSignature: "getTokenEntropy"
  ): TypedContractMethod<[tokenId: BigNumberish], [bigint], "view">;
  getFunction(
    nameOrSignature: "getTokenGeneration"
  ): TypedContractMethod<[tokenId: BigNumberish], [bigint], "view">;
  getFunction(
    nameOrSignature: "getTokenLastTransferredTimestamp"
  ): TypedContractMethod<[tokenId: BigNumberish], [bigint], "view">;
  getFunction(
    nameOrSignature: "isApprovedForAll"
  ): TypedContractMethod<
    [owner: AddressLike, operator: AddressLike],
    [boolean],
    "view"
  >;
  getFunction(
    nameOrSignature: "isApprovedOrOwner"
  ): TypedContractMethod<
    [spender: AddressLike, tokenId: BigNumberish],
    [boolean],
    "view"
  >;
  getFunction(
    nameOrSignature: "isForger"
  ): TypedContractMethod<[tokenId: BigNumberish], [boolean], "view">;
  getFunction(
    nameOrSignature: "mintToken"
  ): TypedContractMethod<[proof: BytesLike[]], [void], "payable">;
  getFunction(
    nameOrSignature: "mintWithBudget"
  ): TypedContractMethod<[proof: BytesLike[]], [void], "payable">;
  getFunction(
    nameOrSignature: "ownerOf"
  ): TypedContractMethod<[tokenId: BigNumberish], [string], "view">;
  getFunction(
    nameOrSignature: "safeTransferFrom(address,address,uint256)"
  ): TypedContractMethod<
    [from: AddressLike, to: AddressLike, tokenId: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "safeTransferFrom(address,address,uint256,bytes)"
  ): TypedContractMethod<
    [
      from: AddressLike,
      to: AddressLike,
      tokenId: BigNumberish,
      data: BytesLike
    ],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "setAirdropContract"
  ): TypedContractMethod<[_airdrop: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setApprovalForAll"
  ): TypedContractMethod<
    [operator: AddressLike, approved: boolean],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "setEntityForgingContract"
  ): TypedContractMethod<
    [_entityForgingAddress: AddressLike],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "setEntropyGenerator"
  ): TypedContractMethod<
    [_entropyGeneratorAddress: AddressLike],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "setNukeFundContract"
  ): TypedContractMethod<[_nukeFundAddress: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setPriceIncrement"
  ): TypedContractMethod<[_priceIncrement: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setPriceIncrementByGen"
  ): TypedContractMethod<
    [_priceIncrementByGen: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "setStartPrice"
  ): TypedContractMethod<[_startPrice: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "startAirdrop"
  ): TypedContractMethod<[amount: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "supportsInterface"
  ): TypedContractMethod<[interfaceId: BytesLike], [boolean], "view">;
  getFunction(
    nameOrSignature: "tokenByIndex"
  ): TypedContractMethod<[index: BigNumberish], [bigint], "view">;
  getFunction(
    nameOrSignature: "tokenOfOwnerByIndex"
  ): TypedContractMethod<
    [owner: AddressLike, index: BigNumberish],
    [bigint],
    "view"
  >;
  getFunction(
    nameOrSignature: "totalSupply"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "transferFrom"
  ): TypedContractMethod<
    [from: AddressLike, to: AddressLike, tokenId: BigNumberish],
    [void],
    "nonpayable"
  >;

  getEvent(
    key: "Approval"
  ): TypedContractEvent<
    ApprovalEvent.InputTuple,
    ApprovalEvent.OutputTuple,
    ApprovalEvent.OutputObject
  >;
  getEvent(
    key: "ApprovalForAll"
  ): TypedContractEvent<
    ApprovalForAllEvent.InputTuple,
    ApprovalForAllEvent.OutputTuple,
    ApprovalForAllEvent.OutputObject
  >;
  getEvent(
    key: "FundsDistributedToNukeFund"
  ): TypedContractEvent<
    FundsDistributedToNukeFundEvent.InputTuple,
    FundsDistributedToNukeFundEvent.OutputTuple,
    FundsDistributedToNukeFundEvent.OutputObject
  >;
  getEvent(
    key: "GenerationIncremented"
  ): TypedContractEvent<
    GenerationIncrementedEvent.InputTuple,
    GenerationIncrementedEvent.OutputTuple,
    GenerationIncrementedEvent.OutputObject
  >;
  getEvent(
    key: "Minted"
  ): TypedContractEvent<
    MintedEvent.InputTuple,
    MintedEvent.OutputTuple,
    MintedEvent.OutputObject
  >;
  getEvent(
    key: "NewEntityMinted"
  ): TypedContractEvent<
    NewEntityMintedEvent.InputTuple,
    NewEntityMintedEvent.OutputTuple,
    NewEntityMintedEvent.OutputObject
  >;
  getEvent(
    key: "NukeFundContractUpdated"
  ): TypedContractEvent<
    NukeFundContractUpdatedEvent.InputTuple,
    NukeFundContractUpdatedEvent.OutputTuple,
    NukeFundContractUpdatedEvent.OutputObject
  >;
  getEvent(
    key: "Transfer"
  ): TypedContractEvent<
    TransferEvent.InputTuple,
    TransferEvent.OutputTuple,
    TransferEvent.OutputObject
  >;

  filters: {
    "Approval(address,address,uint256)": TypedContractEvent<
      ApprovalEvent.InputTuple,
      ApprovalEvent.OutputTuple,
      ApprovalEvent.OutputObject
    >;
    Approval: TypedContractEvent<
      ApprovalEvent.InputTuple,
      ApprovalEvent.OutputTuple,
      ApprovalEvent.OutputObject
    >;

    "ApprovalForAll(address,address,bool)": TypedContractEvent<
      ApprovalForAllEvent.InputTuple,
      ApprovalForAllEvent.OutputTuple,
      ApprovalForAllEvent.OutputObject
    >;
    ApprovalForAll: TypedContractEvent<
      ApprovalForAllEvent.InputTuple,
      ApprovalForAllEvent.OutputTuple,
      ApprovalForAllEvent.OutputObject
    >;

    "FundsDistributedToNukeFund(address,uint256)": TypedContractEvent<
      FundsDistributedToNukeFundEvent.InputTuple,
      FundsDistributedToNukeFundEvent.OutputTuple,
      FundsDistributedToNukeFundEvent.OutputObject
    >;
    FundsDistributedToNukeFund: TypedContractEvent<
      FundsDistributedToNukeFundEvent.InputTuple,
      FundsDistributedToNukeFundEvent.OutputTuple,
      FundsDistributedToNukeFundEvent.OutputObject
    >;

    "GenerationIncremented(uint256)": TypedContractEvent<
      GenerationIncrementedEvent.InputTuple,
      GenerationIncrementedEvent.OutputTuple,
      GenerationIncrementedEvent.OutputObject
    >;
    GenerationIncremented: TypedContractEvent<
      GenerationIncrementedEvent.InputTuple,
      GenerationIncrementedEvent.OutputTuple,
      GenerationIncrementedEvent.OutputObject
    >;

    "Minted(address,uint256,uint256,uint256,uint256)": TypedContractEvent<
      MintedEvent.InputTuple,
      MintedEvent.OutputTuple,
      MintedEvent.OutputObject
    >;
    Minted: TypedContractEvent<
      MintedEvent.InputTuple,
      MintedEvent.OutputTuple,
      MintedEvent.OutputObject
    >;

    "NewEntityMinted(address,uint256,uint256,uint256)": TypedContractEvent<
      NewEntityMintedEvent.InputTuple,
      NewEntityMintedEvent.OutputTuple,
      NewEntityMintedEvent.OutputObject
    >;
    NewEntityMinted: TypedContractEvent<
      NewEntityMintedEvent.InputTuple,
      NewEntityMintedEvent.OutputTuple,
      NewEntityMintedEvent.OutputObject
    >;

    "NukeFundContractUpdated(address)": TypedContractEvent<
      NukeFundContractUpdatedEvent.InputTuple,
      NukeFundContractUpdatedEvent.OutputTuple,
      NukeFundContractUpdatedEvent.OutputObject
    >;
    NukeFundContractUpdated: TypedContractEvent<
      NukeFundContractUpdatedEvent.InputTuple,
      NukeFundContractUpdatedEvent.OutputTuple,
      NukeFundContractUpdatedEvent.OutputObject
    >;

    "Transfer(address,address,uint256)": TypedContractEvent<
      TransferEvent.InputTuple,
      TransferEvent.OutputTuple,
      TransferEvent.OutputObject
    >;
    Transfer: TypedContractEvent<
      TransferEvent.InputTuple,
      TransferEvent.OutputTuple,
      TransferEvent.OutputObject
    >;
  };
}

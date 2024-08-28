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

export declare namespace IEntityForging {
  export type ListingStruct = {
    account: AddressLike;
    tokenId: BigNumberish;
    isListed: boolean;
    fee: BigNumberish;
  };

  export type ListingStructOutput = [
    account: string,
    tokenId: bigint,
    isListed: boolean,
    fee: bigint
  ] & { account: string; tokenId: bigint; isListed: boolean; fee: bigint };
}

export interface EntityForgingInterface extends Interface {
  getFunction(
    nameOrSignature:
      | "cancelListingForForging"
      | "fetchListings"
      | "forgeWithListed"
      | "forgingCounts"
      | "getListedTokenIds"
      | "getListings"
      | "listForForging"
      | "listedTokenIds"
      | "listingCount"
      | "listings"
      | "minimumListFee"
      | "nftContract"
      | "nukeFundAddress"
      | "oneYearInDays"
      | "owner"
      | "pause"
      | "paused"
      | "renounceOwnership"
      | "setMinimumListingFee"
      | "setNukeFundAddress"
      | "setOneYearInDays"
      | "setTaxCut"
      | "taxCut"
      | "transferOwnership"
      | "unpause"
  ): FunctionFragment;

  getEvent(
    nameOrSignatureOrTopic:
      | "CancelledListingForForging"
      | "EntityForged"
      | "ListedForForging"
      | "OwnershipTransferred"
      | "Paused"
      | "Unpaused"
  ): EventFragment;

  encodeFunctionData(
    functionFragment: "cancelListingForForging",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "fetchListings",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "forgeWithListed",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "forgingCounts",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "getListedTokenIds",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "getListings",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "listForForging",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "listedTokenIds",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "listingCount",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "listings",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "minimumListFee",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "nftContract",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "nukeFundAddress",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "oneYearInDays",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "owner", values?: undefined): string;
  encodeFunctionData(functionFragment: "pause", values?: undefined): string;
  encodeFunctionData(functionFragment: "paused", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "renounceOwnership",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "setMinimumListingFee",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setNukeFundAddress",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setOneYearInDays",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setTaxCut",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(functionFragment: "taxCut", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "transferOwnership",
    values: [AddressLike]
  ): string;
  encodeFunctionData(functionFragment: "unpause", values?: undefined): string;

  decodeFunctionResult(
    functionFragment: "cancelListingForForging",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "fetchListings",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "forgeWithListed",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "forgingCounts",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getListedTokenIds",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getListings",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "listForForging",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "listedTokenIds",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "listingCount",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "listings", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "minimumListFee",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "nftContract",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "nukeFundAddress",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "oneYearInDays",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "owner", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "pause", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "paused", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "renounceOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setMinimumListingFee",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setNukeFundAddress",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setOneYearInDays",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "setTaxCut", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "taxCut", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "transferOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "unpause", data: BytesLike): Result;
}

export namespace CancelledListingForForgingEvent {
  export type InputTuple = [tokenId: BigNumberish];
  export type OutputTuple = [tokenId: bigint];
  export interface OutputObject {
    tokenId: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace EntityForgedEvent {
  export type InputTuple = [
    newTokenid: BigNumberish,
    parent1Id: BigNumberish,
    parent2Id: BigNumberish,
    newEntropy: BigNumberish,
    forgingFee: BigNumberish
  ];
  export type OutputTuple = [
    newTokenid: bigint,
    parent1Id: bigint,
    parent2Id: bigint,
    newEntropy: bigint,
    forgingFee: bigint
  ];
  export interface OutputObject {
    newTokenid: bigint;
    parent1Id: bigint;
    parent2Id: bigint;
    newEntropy: bigint;
    forgingFee: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace ListedForForgingEvent {
  export type InputTuple = [tokenId: BigNumberish, fee: BigNumberish];
  export type OutputTuple = [tokenId: bigint, fee: bigint];
  export interface OutputObject {
    tokenId: bigint;
    fee: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace OwnershipTransferredEvent {
  export type InputTuple = [previousOwner: AddressLike, newOwner: AddressLike];
  export type OutputTuple = [previousOwner: string, newOwner: string];
  export interface OutputObject {
    previousOwner: string;
    newOwner: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace PausedEvent {
  export type InputTuple = [account: AddressLike];
  export type OutputTuple = [account: string];
  export interface OutputObject {
    account: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace UnpausedEvent {
  export type InputTuple = [account: AddressLike];
  export type OutputTuple = [account: string];
  export interface OutputObject {
    account: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export interface EntityForging extends BaseContract {
  connect(runner?: ContractRunner | null): EntityForging;
  waitForDeployment(): Promise<this>;

  interface: EntityForgingInterface;

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

  cancelListingForForging: TypedContractMethod<
    [tokenId: BigNumberish],
    [void],
    "nonpayable"
  >;

  fetchListings: TypedContractMethod<
    [],
    [IEntityForging.ListingStructOutput[]],
    "view"
  >;

  forgeWithListed: TypedContractMethod<
    [forgerTokenId: BigNumberish, mergerTokenId: BigNumberish],
    [bigint],
    "payable"
  >;

  forgingCounts: TypedContractMethod<[arg0: BigNumberish], [bigint], "view">;

  getListedTokenIds: TypedContractMethod<
    [tokenId_: BigNumberish],
    [bigint],
    "view"
  >;

  getListings: TypedContractMethod<
    [id: BigNumberish],
    [IEntityForging.ListingStructOutput],
    "view"
  >;

  listForForging: TypedContractMethod<
    [tokenId: BigNumberish, fee: BigNumberish],
    [void],
    "nonpayable"
  >;

  listedTokenIds: TypedContractMethod<[arg0: BigNumberish], [bigint], "view">;

  listingCount: TypedContractMethod<[], [bigint], "view">;

  listings: TypedContractMethod<
    [arg0: BigNumberish],
    [
      [string, bigint, boolean, bigint] & {
        account: string;
        tokenId: bigint;
        isListed: boolean;
        fee: bigint;
      }
    ],
    "view"
  >;

  minimumListFee: TypedContractMethod<[], [bigint], "view">;

  nftContract: TypedContractMethod<[], [string], "view">;

  nukeFundAddress: TypedContractMethod<[], [string], "view">;

  oneYearInDays: TypedContractMethod<[], [bigint], "view">;

  owner: TypedContractMethod<[], [string], "view">;

  pause: TypedContractMethod<[], [void], "nonpayable">;

  paused: TypedContractMethod<[], [boolean], "view">;

  renounceOwnership: TypedContractMethod<[], [void], "nonpayable">;

  setMinimumListingFee: TypedContractMethod<
    [_fee: BigNumberish],
    [void],
    "nonpayable"
  >;

  setNukeFundAddress: TypedContractMethod<
    [_nukeFundAddress: AddressLike],
    [void],
    "nonpayable"
  >;

  setOneYearInDays: TypedContractMethod<
    [value: BigNumberish],
    [void],
    "nonpayable"
  >;

  setTaxCut: TypedContractMethod<[_taxCut: BigNumberish], [void], "nonpayable">;

  taxCut: TypedContractMethod<[], [bigint], "view">;

  transferOwnership: TypedContractMethod<
    [newOwner: AddressLike],
    [void],
    "nonpayable"
  >;

  unpause: TypedContractMethod<[], [void], "nonpayable">;

  getFunction<T extends ContractMethod = ContractMethod>(
    key: string | FunctionFragment
  ): T;

  getFunction(
    nameOrSignature: "cancelListingForForging"
  ): TypedContractMethod<[tokenId: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "fetchListings"
  ): TypedContractMethod<[], [IEntityForging.ListingStructOutput[]], "view">;
  getFunction(
    nameOrSignature: "forgeWithListed"
  ): TypedContractMethod<
    [forgerTokenId: BigNumberish, mergerTokenId: BigNumberish],
    [bigint],
    "payable"
  >;
  getFunction(
    nameOrSignature: "forgingCounts"
  ): TypedContractMethod<[arg0: BigNumberish], [bigint], "view">;
  getFunction(
    nameOrSignature: "getListedTokenIds"
  ): TypedContractMethod<[tokenId_: BigNumberish], [bigint], "view">;
  getFunction(
    nameOrSignature: "getListings"
  ): TypedContractMethod<
    [id: BigNumberish],
    [IEntityForging.ListingStructOutput],
    "view"
  >;
  getFunction(
    nameOrSignature: "listForForging"
  ): TypedContractMethod<
    [tokenId: BigNumberish, fee: BigNumberish],
    [void],
    "nonpayable"
  >;
  getFunction(
    nameOrSignature: "listedTokenIds"
  ): TypedContractMethod<[arg0: BigNumberish], [bigint], "view">;
  getFunction(
    nameOrSignature: "listingCount"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "listings"
  ): TypedContractMethod<
    [arg0: BigNumberish],
    [
      [string, bigint, boolean, bigint] & {
        account: string;
        tokenId: bigint;
        isListed: boolean;
        fee: bigint;
      }
    ],
    "view"
  >;
  getFunction(
    nameOrSignature: "minimumListFee"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "nftContract"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "nukeFundAddress"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "oneYearInDays"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "owner"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "pause"
  ): TypedContractMethod<[], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "paused"
  ): TypedContractMethod<[], [boolean], "view">;
  getFunction(
    nameOrSignature: "renounceOwnership"
  ): TypedContractMethod<[], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setMinimumListingFee"
  ): TypedContractMethod<[_fee: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setNukeFundAddress"
  ): TypedContractMethod<[_nukeFundAddress: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setOneYearInDays"
  ): TypedContractMethod<[value: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setTaxCut"
  ): TypedContractMethod<[_taxCut: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "taxCut"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "transferOwnership"
  ): TypedContractMethod<[newOwner: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "unpause"
  ): TypedContractMethod<[], [void], "nonpayable">;

  getEvent(
    key: "CancelledListingForForging"
  ): TypedContractEvent<
    CancelledListingForForgingEvent.InputTuple,
    CancelledListingForForgingEvent.OutputTuple,
    CancelledListingForForgingEvent.OutputObject
  >;
  getEvent(
    key: "EntityForged"
  ): TypedContractEvent<
    EntityForgedEvent.InputTuple,
    EntityForgedEvent.OutputTuple,
    EntityForgedEvent.OutputObject
  >;
  getEvent(
    key: "ListedForForging"
  ): TypedContractEvent<
    ListedForForgingEvent.InputTuple,
    ListedForForgingEvent.OutputTuple,
    ListedForForgingEvent.OutputObject
  >;
  getEvent(
    key: "OwnershipTransferred"
  ): TypedContractEvent<
    OwnershipTransferredEvent.InputTuple,
    OwnershipTransferredEvent.OutputTuple,
    OwnershipTransferredEvent.OutputObject
  >;
  getEvent(
    key: "Paused"
  ): TypedContractEvent<
    PausedEvent.InputTuple,
    PausedEvent.OutputTuple,
    PausedEvent.OutputObject
  >;
  getEvent(
    key: "Unpaused"
  ): TypedContractEvent<
    UnpausedEvent.InputTuple,
    UnpausedEvent.OutputTuple,
    UnpausedEvent.OutputObject
  >;

  filters: {
    "CancelledListingForForging(uint256)": TypedContractEvent<
      CancelledListingForForgingEvent.InputTuple,
      CancelledListingForForgingEvent.OutputTuple,
      CancelledListingForForgingEvent.OutputObject
    >;
    CancelledListingForForging: TypedContractEvent<
      CancelledListingForForgingEvent.InputTuple,
      CancelledListingForForgingEvent.OutputTuple,
      CancelledListingForForgingEvent.OutputObject
    >;

    "EntityForged(uint256,uint256,uint256,uint256,uint256)": TypedContractEvent<
      EntityForgedEvent.InputTuple,
      EntityForgedEvent.OutputTuple,
      EntityForgedEvent.OutputObject
    >;
    EntityForged: TypedContractEvent<
      EntityForgedEvent.InputTuple,
      EntityForgedEvent.OutputTuple,
      EntityForgedEvent.OutputObject
    >;

    "ListedForForging(uint256,uint256)": TypedContractEvent<
      ListedForForgingEvent.InputTuple,
      ListedForForgingEvent.OutputTuple,
      ListedForForgingEvent.OutputObject
    >;
    ListedForForging: TypedContractEvent<
      ListedForForgingEvent.InputTuple,
      ListedForForgingEvent.OutputTuple,
      ListedForForgingEvent.OutputObject
    >;

    "OwnershipTransferred(address,address)": TypedContractEvent<
      OwnershipTransferredEvent.InputTuple,
      OwnershipTransferredEvent.OutputTuple,
      OwnershipTransferredEvent.OutputObject
    >;
    OwnershipTransferred: TypedContractEvent<
      OwnershipTransferredEvent.InputTuple,
      OwnershipTransferredEvent.OutputTuple,
      OwnershipTransferredEvent.OutputObject
    >;

    "Paused(address)": TypedContractEvent<
      PausedEvent.InputTuple,
      PausedEvent.OutputTuple,
      PausedEvent.OutputObject
    >;
    Paused: TypedContractEvent<
      PausedEvent.InputTuple,
      PausedEvent.OutputTuple,
      PausedEvent.OutputObject
    >;

    "Unpaused(address)": TypedContractEvent<
      UnpausedEvent.InputTuple,
      UnpausedEvent.OutputTuple,
      UnpausedEvent.OutputObject
    >;
    Unpaused: TypedContractEvent<
      UnpausedEvent.InputTuple,
      UnpausedEvent.OutputTuple,
      UnpausedEvent.OutputObject
    >;
  };
}

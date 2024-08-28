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

export interface NukeFundInterface extends Interface {
  getFunction(
    nameOrSignature:
      | "MAX_DENOMINATOR"
      | "airdropContract"
      | "calculateAge"
      | "calculateNukeFactor"
      | "canTokenBeNuked"
      | "daoAddress"
      | "defaultNukeFactorIncrease"
      | "devAddress"
      | "getFundBalance"
      | "maxAllowedClaimDivisor"
      | "minimumDaysHeld"
      | "nftContract"
      | "nuke"
      | "nukeFactorMaxParam"
      | "owner"
      | "pause"
      | "paused"
      | "renounceOwnership"
      | "setAirdropContract"
      | "setDaoAddress"
      | "setDefaultNukeFactorIncrease"
      | "setDevAddress"
      | "setMaxAllowedClaimDivisor"
      | "setMinimumDaysHeld"
      | "setNukeFactorMaxParam"
      | "setTaxCut"
      | "setTraitForgeNftContract"
      | "taxCut"
      | "transferOwnership"
      | "unpause"
  ): FunctionFragment;

  getEvent(
    nameOrSignatureOrTopic:
      | "AirdropAddressUpdated"
      | "DaoAddressUpdated"
      | "DevAddressUpdated"
      | "DevShareDistributed"
      | "FundBalanceUpdated"
      | "FundReceived"
      | "Nuked"
      | "OwnershipTransferred"
      | "Paused"
      | "TraitForgeNftAddressUpdated"
      | "Unpaused"
  ): EventFragment;

  encodeFunctionData(
    functionFragment: "MAX_DENOMINATOR",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "airdropContract",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "calculateAge",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "calculateNukeFactor",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "canTokenBeNuked",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "daoAddress",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "defaultNukeFactorIncrease",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "devAddress",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getFundBalance",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "maxAllowedClaimDivisor",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "minimumDaysHeld",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "nftContract",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "nuke", values: [BigNumberish]): string;
  encodeFunctionData(
    functionFragment: "nukeFactorMaxParam",
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
    functionFragment: "setAirdropContract",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setDaoAddress",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setDefaultNukeFactorIncrease",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setDevAddress",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "setMaxAllowedClaimDivisor",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setMinimumDaysHeld",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setNukeFactorMaxParam",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setTaxCut",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setTraitForgeNftContract",
    values: [AddressLike]
  ): string;
  encodeFunctionData(functionFragment: "taxCut", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "transferOwnership",
    values: [AddressLike]
  ): string;
  encodeFunctionData(functionFragment: "unpause", values?: undefined): string;

  decodeFunctionResult(
    functionFragment: "MAX_DENOMINATOR",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "airdropContract",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "calculateAge",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "calculateNukeFactor",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "canTokenBeNuked",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "daoAddress", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "defaultNukeFactorIncrease",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "devAddress", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "getFundBalance",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "maxAllowedClaimDivisor",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "minimumDaysHeld",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "nftContract",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "nuke", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "nukeFactorMaxParam",
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
    functionFragment: "setAirdropContract",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setDaoAddress",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setDefaultNukeFactorIncrease",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setDevAddress",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setMaxAllowedClaimDivisor",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setMinimumDaysHeld",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setNukeFactorMaxParam",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "setTaxCut", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "setTraitForgeNftContract",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "taxCut", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "transferOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "unpause", data: BytesLike): Result;
}

export namespace AirdropAddressUpdatedEvent {
  export type InputTuple = [newAddress: AddressLike];
  export type OutputTuple = [newAddress: string];
  export interface OutputObject {
    newAddress: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace DaoAddressUpdatedEvent {
  export type InputTuple = [newAddress: AddressLike];
  export type OutputTuple = [newAddress: string];
  export interface OutputObject {
    newAddress: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace DevAddressUpdatedEvent {
  export type InputTuple = [newAddress: AddressLike];
  export type OutputTuple = [newAddress: string];
  export interface OutputObject {
    newAddress: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace DevShareDistributedEvent {
  export type InputTuple = [devShare: BigNumberish];
  export type OutputTuple = [devShare: bigint];
  export interface OutputObject {
    devShare: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace FundBalanceUpdatedEvent {
  export type InputTuple = [newBalance: BigNumberish];
  export type OutputTuple = [newBalance: bigint];
  export interface OutputObject {
    newBalance: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace FundReceivedEvent {
  export type InputTuple = [from: AddressLike, amount: BigNumberish];
  export type OutputTuple = [from: string, amount: bigint];
  export interface OutputObject {
    from: string;
    amount: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace NukedEvent {
  export type InputTuple = [
    owner: AddressLike,
    tokenId: BigNumberish,
    nukeAmount: BigNumberish
  ];
  export type OutputTuple = [
    owner: string,
    tokenId: bigint,
    nukeAmount: bigint
  ];
  export interface OutputObject {
    owner: string;
    tokenId: bigint;
    nukeAmount: bigint;
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

export namespace TraitForgeNftAddressUpdatedEvent {
  export type InputTuple = [newAddress: AddressLike];
  export type OutputTuple = [newAddress: string];
  export interface OutputObject {
    newAddress: string;
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

export interface NukeFund extends BaseContract {
  connect(runner?: ContractRunner | null): NukeFund;
  waitForDeployment(): Promise<this>;

  interface: NukeFundInterface;

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

  MAX_DENOMINATOR: TypedContractMethod<[], [bigint], "view">;

  airdropContract: TypedContractMethod<[], [string], "view">;

  calculateAge: TypedContractMethod<[tokenId: BigNumberish], [bigint], "view">;

  calculateNukeFactor: TypedContractMethod<
    [tokenId: BigNumberish],
    [bigint],
    "view"
  >;

  canTokenBeNuked: TypedContractMethod<
    [tokenId: BigNumberish],
    [boolean],
    "view"
  >;

  daoAddress: TypedContractMethod<[], [string], "view">;

  defaultNukeFactorIncrease: TypedContractMethod<[], [bigint], "view">;

  devAddress: TypedContractMethod<[], [string], "view">;

  getFundBalance: TypedContractMethod<[], [bigint], "view">;

  maxAllowedClaimDivisor: TypedContractMethod<[], [bigint], "view">;

  minimumDaysHeld: TypedContractMethod<[], [bigint], "view">;

  nftContract: TypedContractMethod<[], [string], "view">;

  nuke: TypedContractMethod<[tokenId: BigNumberish], [void], "nonpayable">;

  nukeFactorMaxParam: TypedContractMethod<[], [bigint], "view">;

  owner: TypedContractMethod<[], [string], "view">;

  pause: TypedContractMethod<[], [void], "nonpayable">;

  paused: TypedContractMethod<[], [boolean], "view">;

  renounceOwnership: TypedContractMethod<[], [void], "nonpayable">;

  setAirdropContract: TypedContractMethod<
    [_airdrop: AddressLike],
    [void],
    "nonpayable"
  >;

  setDaoAddress: TypedContractMethod<
    [account: AddressLike],
    [void],
    "nonpayable"
  >;

  setDefaultNukeFactorIncrease: TypedContractMethod<
    [value: BigNumberish],
    [void],
    "nonpayable"
  >;

  setDevAddress: TypedContractMethod<
    [account: AddressLike],
    [void],
    "nonpayable"
  >;

  setMaxAllowedClaimDivisor: TypedContractMethod<
    [value: BigNumberish],
    [void],
    "nonpayable"
  >;

  setMinimumDaysHeld: TypedContractMethod<
    [value: BigNumberish],
    [void],
    "nonpayable"
  >;

  setNukeFactorMaxParam: TypedContractMethod<
    [value: BigNumberish],
    [void],
    "nonpayable"
  >;

  setTaxCut: TypedContractMethod<[_taxCut: BigNumberish], [void], "nonpayable">;

  setTraitForgeNftContract: TypedContractMethod<
    [_traitForgeNft: AddressLike],
    [void],
    "nonpayable"
  >;

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
    nameOrSignature: "MAX_DENOMINATOR"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "airdropContract"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "calculateAge"
  ): TypedContractMethod<[tokenId: BigNumberish], [bigint], "view">;
  getFunction(
    nameOrSignature: "calculateNukeFactor"
  ): TypedContractMethod<[tokenId: BigNumberish], [bigint], "view">;
  getFunction(
    nameOrSignature: "canTokenBeNuked"
  ): TypedContractMethod<[tokenId: BigNumberish], [boolean], "view">;
  getFunction(
    nameOrSignature: "daoAddress"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "defaultNukeFactorIncrease"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "devAddress"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "getFundBalance"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "maxAllowedClaimDivisor"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "minimumDaysHeld"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "nftContract"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "nuke"
  ): TypedContractMethod<[tokenId: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "nukeFactorMaxParam"
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
    nameOrSignature: "setAirdropContract"
  ): TypedContractMethod<[_airdrop: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setDaoAddress"
  ): TypedContractMethod<[account: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setDefaultNukeFactorIncrease"
  ): TypedContractMethod<[value: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setDevAddress"
  ): TypedContractMethod<[account: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setMaxAllowedClaimDivisor"
  ): TypedContractMethod<[value: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setMinimumDaysHeld"
  ): TypedContractMethod<[value: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setNukeFactorMaxParam"
  ): TypedContractMethod<[value: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setTaxCut"
  ): TypedContractMethod<[_taxCut: BigNumberish], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setTraitForgeNftContract"
  ): TypedContractMethod<[_traitForgeNft: AddressLike], [void], "nonpayable">;
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
    key: "AirdropAddressUpdated"
  ): TypedContractEvent<
    AirdropAddressUpdatedEvent.InputTuple,
    AirdropAddressUpdatedEvent.OutputTuple,
    AirdropAddressUpdatedEvent.OutputObject
  >;
  getEvent(
    key: "DaoAddressUpdated"
  ): TypedContractEvent<
    DaoAddressUpdatedEvent.InputTuple,
    DaoAddressUpdatedEvent.OutputTuple,
    DaoAddressUpdatedEvent.OutputObject
  >;
  getEvent(
    key: "DevAddressUpdated"
  ): TypedContractEvent<
    DevAddressUpdatedEvent.InputTuple,
    DevAddressUpdatedEvent.OutputTuple,
    DevAddressUpdatedEvent.OutputObject
  >;
  getEvent(
    key: "DevShareDistributed"
  ): TypedContractEvent<
    DevShareDistributedEvent.InputTuple,
    DevShareDistributedEvent.OutputTuple,
    DevShareDistributedEvent.OutputObject
  >;
  getEvent(
    key: "FundBalanceUpdated"
  ): TypedContractEvent<
    FundBalanceUpdatedEvent.InputTuple,
    FundBalanceUpdatedEvent.OutputTuple,
    FundBalanceUpdatedEvent.OutputObject
  >;
  getEvent(
    key: "FundReceived"
  ): TypedContractEvent<
    FundReceivedEvent.InputTuple,
    FundReceivedEvent.OutputTuple,
    FundReceivedEvent.OutputObject
  >;
  getEvent(
    key: "Nuked"
  ): TypedContractEvent<
    NukedEvent.InputTuple,
    NukedEvent.OutputTuple,
    NukedEvent.OutputObject
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
    key: "TraitForgeNftAddressUpdated"
  ): TypedContractEvent<
    TraitForgeNftAddressUpdatedEvent.InputTuple,
    TraitForgeNftAddressUpdatedEvent.OutputTuple,
    TraitForgeNftAddressUpdatedEvent.OutputObject
  >;
  getEvent(
    key: "Unpaused"
  ): TypedContractEvent<
    UnpausedEvent.InputTuple,
    UnpausedEvent.OutputTuple,
    UnpausedEvent.OutputObject
  >;

  filters: {
    "AirdropAddressUpdated(address)": TypedContractEvent<
      AirdropAddressUpdatedEvent.InputTuple,
      AirdropAddressUpdatedEvent.OutputTuple,
      AirdropAddressUpdatedEvent.OutputObject
    >;
    AirdropAddressUpdated: TypedContractEvent<
      AirdropAddressUpdatedEvent.InputTuple,
      AirdropAddressUpdatedEvent.OutputTuple,
      AirdropAddressUpdatedEvent.OutputObject
    >;

    "DaoAddressUpdated(address)": TypedContractEvent<
      DaoAddressUpdatedEvent.InputTuple,
      DaoAddressUpdatedEvent.OutputTuple,
      DaoAddressUpdatedEvent.OutputObject
    >;
    DaoAddressUpdated: TypedContractEvent<
      DaoAddressUpdatedEvent.InputTuple,
      DaoAddressUpdatedEvent.OutputTuple,
      DaoAddressUpdatedEvent.OutputObject
    >;

    "DevAddressUpdated(address)": TypedContractEvent<
      DevAddressUpdatedEvent.InputTuple,
      DevAddressUpdatedEvent.OutputTuple,
      DevAddressUpdatedEvent.OutputObject
    >;
    DevAddressUpdated: TypedContractEvent<
      DevAddressUpdatedEvent.InputTuple,
      DevAddressUpdatedEvent.OutputTuple,
      DevAddressUpdatedEvent.OutputObject
    >;

    "DevShareDistributed(uint256)": TypedContractEvent<
      DevShareDistributedEvent.InputTuple,
      DevShareDistributedEvent.OutputTuple,
      DevShareDistributedEvent.OutputObject
    >;
    DevShareDistributed: TypedContractEvent<
      DevShareDistributedEvent.InputTuple,
      DevShareDistributedEvent.OutputTuple,
      DevShareDistributedEvent.OutputObject
    >;

    "FundBalanceUpdated(uint256)": TypedContractEvent<
      FundBalanceUpdatedEvent.InputTuple,
      FundBalanceUpdatedEvent.OutputTuple,
      FundBalanceUpdatedEvent.OutputObject
    >;
    FundBalanceUpdated: TypedContractEvent<
      FundBalanceUpdatedEvent.InputTuple,
      FundBalanceUpdatedEvent.OutputTuple,
      FundBalanceUpdatedEvent.OutputObject
    >;

    "FundReceived(address,uint256)": TypedContractEvent<
      FundReceivedEvent.InputTuple,
      FundReceivedEvent.OutputTuple,
      FundReceivedEvent.OutputObject
    >;
    FundReceived: TypedContractEvent<
      FundReceivedEvent.InputTuple,
      FundReceivedEvent.OutputTuple,
      FundReceivedEvent.OutputObject
    >;

    "Nuked(address,uint256,uint256)": TypedContractEvent<
      NukedEvent.InputTuple,
      NukedEvent.OutputTuple,
      NukedEvent.OutputObject
    >;
    Nuked: TypedContractEvent<
      NukedEvent.InputTuple,
      NukedEvent.OutputTuple,
      NukedEvent.OutputObject
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

    "TraitForgeNftAddressUpdated(address)": TypedContractEvent<
      TraitForgeNftAddressUpdatedEvent.InputTuple,
      TraitForgeNftAddressUpdatedEvent.OutputTuple,
      TraitForgeNftAddressUpdatedEvent.OutputObject
    >;
    TraitForgeNftAddressUpdated: TypedContractEvent<
      TraitForgeNftAddressUpdatedEvent.InputTuple,
      TraitForgeNftAddressUpdatedEvent.OutputTuple,
      TraitForgeNftAddressUpdatedEvent.OutputObject
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

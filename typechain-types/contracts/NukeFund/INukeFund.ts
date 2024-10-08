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

export interface INukeFundInterface extends Interface {
  getFunction(
    nameOrSignature:
      | "calculateAge"
      | "calculateNukeFactor"
      | "canTokenBeNuked"
      | "getFundBalance"
      | "nuke"
      | "setAirdropContract"
      | "setDaoAddress"
      | "setDefaultNukeFactorIncrease"
      | "setDevAddress"
      | "setMaxAllowedClaimDivisor"
      | "setMinimumDaysHeld"
      | "setNukeFactorMaxParam"
      | "setTaxCut"
      | "setTraitForgeNftContract"
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
      | "TraitForgeNftAddressUpdated"
  ): EventFragment;

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
    functionFragment: "getFundBalance",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "nuke", values: [BigNumberish]): string;
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
  decodeFunctionResult(
    functionFragment: "getFundBalance",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "nuke", data: BytesLike): Result;
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

export interface INukeFund extends BaseContract {
  connect(runner?: ContractRunner | null): INukeFund;
  waitForDeployment(): Promise<this>;

  interface: INukeFundInterface;

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

  getFundBalance: TypedContractMethod<[], [bigint], "view">;

  nuke: TypedContractMethod<[tokenId: BigNumberish], [void], "nonpayable">;

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

  getFunction<T extends ContractMethod = ContractMethod>(
    key: string | FunctionFragment
  ): T;

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
    nameOrSignature: "getFundBalance"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "nuke"
  ): TypedContractMethod<[tokenId: BigNumberish], [void], "nonpayable">;
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
    key: "TraitForgeNftAddressUpdated"
  ): TypedContractEvent<
    TraitForgeNftAddressUpdatedEvent.InputTuple,
    TraitForgeNftAddressUpdatedEvent.OutputTuple,
    TraitForgeNftAddressUpdatedEvent.OutputObject
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
  };
}

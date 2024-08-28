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

export interface IEntropyGeneratorInterface extends Interface {
  getFunction(
    nameOrSignature:
      | "getAllowedCaller"
      | "getLastInitializedIndex"
      | "getNextEntropy"
      | "getPublicEntropy"
      | "initializeAlphaIndices"
      | "setAllowedCaller"
      | "writeEntropyBatch"
  ): FunctionFragment;

  getEvent(
    nameOrSignatureOrTopic: "AllowedCallerUpdated" | "EntropyRetrieved"
  ): EventFragment;

  encodeFunctionData(
    functionFragment: "getAllowedCaller",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getLastInitializedIndex",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getNextEntropy",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getPublicEntropy",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "initializeAlphaIndices",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "setAllowedCaller",
    values: [AddressLike]
  ): string;
  encodeFunctionData(
    functionFragment: "writeEntropyBatch",
    values?: undefined
  ): string;

  decodeFunctionResult(
    functionFragment: "getAllowedCaller",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getLastInitializedIndex",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getNextEntropy",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getPublicEntropy",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "initializeAlphaIndices",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setAllowedCaller",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "writeEntropyBatch",
    data: BytesLike
  ): Result;
}

export namespace AllowedCallerUpdatedEvent {
  export type InputTuple = [allowedCaller: AddressLike];
  export type OutputTuple = [allowedCaller: string];
  export interface OutputObject {
    allowedCaller: string;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export namespace EntropyRetrievedEvent {
  export type InputTuple = [entropy: BigNumberish];
  export type OutputTuple = [entropy: bigint];
  export interface OutputObject {
    entropy: bigint;
  }
  export type Event = TypedContractEvent<InputTuple, OutputTuple, OutputObject>;
  export type Filter = TypedDeferredTopicFilter<Event>;
  export type Log = TypedEventLog<Event>;
  export type LogDescription = TypedLogDescription<Event>;
}

export interface IEntropyGenerator extends BaseContract {
  connect(runner?: ContractRunner | null): IEntropyGenerator;
  waitForDeployment(): Promise<this>;

  interface: IEntropyGeneratorInterface;

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

  getAllowedCaller: TypedContractMethod<[], [string], "view">;

  getLastInitializedIndex: TypedContractMethod<[], [bigint], "view">;

  getNextEntropy: TypedContractMethod<[], [bigint], "nonpayable">;

  getPublicEntropy: TypedContractMethod<
    [slotIndex: BigNumberish, numberIndex: BigNumberish],
    [bigint],
    "view"
  >;

  initializeAlphaIndices: TypedContractMethod<[], [void], "nonpayable">;

  setAllowedCaller: TypedContractMethod<
    [_allowedCaller: AddressLike],
    [void],
    "nonpayable"
  >;

  writeEntropyBatch: TypedContractMethod<[], [void], "nonpayable">;

  getFunction<T extends ContractMethod = ContractMethod>(
    key: string | FunctionFragment
  ): T;

  getFunction(
    nameOrSignature: "getAllowedCaller"
  ): TypedContractMethod<[], [string], "view">;
  getFunction(
    nameOrSignature: "getLastInitializedIndex"
  ): TypedContractMethod<[], [bigint], "view">;
  getFunction(
    nameOrSignature: "getNextEntropy"
  ): TypedContractMethod<[], [bigint], "nonpayable">;
  getFunction(
    nameOrSignature: "getPublicEntropy"
  ): TypedContractMethod<
    [slotIndex: BigNumberish, numberIndex: BigNumberish],
    [bigint],
    "view"
  >;
  getFunction(
    nameOrSignature: "initializeAlphaIndices"
  ): TypedContractMethod<[], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "setAllowedCaller"
  ): TypedContractMethod<[_allowedCaller: AddressLike], [void], "nonpayable">;
  getFunction(
    nameOrSignature: "writeEntropyBatch"
  ): TypedContractMethod<[], [void], "nonpayable">;

  getEvent(
    key: "AllowedCallerUpdated"
  ): TypedContractEvent<
    AllowedCallerUpdatedEvent.InputTuple,
    AllowedCallerUpdatedEvent.OutputTuple,
    AllowedCallerUpdatedEvent.OutputObject
  >;
  getEvent(
    key: "EntropyRetrieved"
  ): TypedContractEvent<
    EntropyRetrievedEvent.InputTuple,
    EntropyRetrievedEvent.OutputTuple,
    EntropyRetrievedEvent.OutputObject
  >;

  filters: {
    "AllowedCallerUpdated(address)": TypedContractEvent<
      AllowedCallerUpdatedEvent.InputTuple,
      AllowedCallerUpdatedEvent.OutputTuple,
      AllowedCallerUpdatedEvent.OutputObject
    >;
    AllowedCallerUpdated: TypedContractEvent<
      AllowedCallerUpdatedEvent.InputTuple,
      AllowedCallerUpdatedEvent.OutputTuple,
      AllowedCallerUpdatedEvent.OutputObject
    >;

    "EntropyRetrieved(uint256)": TypedContractEvent<
      EntropyRetrievedEvent.InputTuple,
      EntropyRetrievedEvent.OutputTuple,
      EntropyRetrievedEvent.OutputObject
    >;
    EntropyRetrieved: TypedContractEvent<
      EntropyRetrievedEvent.InputTuple,
      EntropyRetrievedEvent.OutputTuple,
      EntropyRetrievedEvent.OutputObject
    >;
  };
}

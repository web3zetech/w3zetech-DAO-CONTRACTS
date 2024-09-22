import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt, Bytes } from "@graphprotocol/graph-ts"
import {
  ConfirmTransaction,
  Deposit,
  ExecuteTransaction,
  RevokeConfirmation,
  SubmitTransaction
} from "../generated/MultiSigWallet/MultiSigWallet"

export function createConfirmTransactionEvent(
  owner: Address,
  txIndex: BigInt
): ConfirmTransaction {
  let confirmTransactionEvent = changetype<ConfirmTransaction>(newMockEvent())

  confirmTransactionEvent.parameters = new Array()

  confirmTransactionEvent.parameters.push(
    new ethereum.EventParam("owner", ethereum.Value.fromAddress(owner))
  )
  confirmTransactionEvent.parameters.push(
    new ethereum.EventParam(
      "txIndex",
      ethereum.Value.fromUnsignedBigInt(txIndex)
    )
  )

  return confirmTransactionEvent
}

export function createDepositEvent(
  sender: Address,
  amount: BigInt,
  balance: BigInt
): Deposit {
  let depositEvent = changetype<Deposit>(newMockEvent())

  depositEvent.parameters = new Array()

  depositEvent.parameters.push(
    new ethereum.EventParam("sender", ethereum.Value.fromAddress(sender))
  )
  depositEvent.parameters.push(
    new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(amount))
  )
  depositEvent.parameters.push(
    new ethereum.EventParam(
      "balance",
      ethereum.Value.fromUnsignedBigInt(balance)
    )
  )

  return depositEvent
}

export function createExecuteTransactionEvent(
  owner: Address,
  txIndex: BigInt
): ExecuteTransaction {
  let executeTransactionEvent = changetype<ExecuteTransaction>(newMockEvent())

  executeTransactionEvent.parameters = new Array()

  executeTransactionEvent.parameters.push(
    new ethereum.EventParam("owner", ethereum.Value.fromAddress(owner))
  )
  executeTransactionEvent.parameters.push(
    new ethereum.EventParam(
      "txIndex",
      ethereum.Value.fromUnsignedBigInt(txIndex)
    )
  )

  return executeTransactionEvent
}

export function createRevokeConfirmationEvent(
  owner: Address,
  txIndex: BigInt
): RevokeConfirmation {
  let revokeConfirmationEvent = changetype<RevokeConfirmation>(newMockEvent())

  revokeConfirmationEvent.parameters = new Array()

  revokeConfirmationEvent.parameters.push(
    new ethereum.EventParam("owner", ethereum.Value.fromAddress(owner))
  )
  revokeConfirmationEvent.parameters.push(
    new ethereum.EventParam(
      "txIndex",
      ethereum.Value.fromUnsignedBigInt(txIndex)
    )
  )

  return revokeConfirmationEvent
}

export function createSubmitTransactionEvent(
  owner: Address,
  txIndex: BigInt,
  to: Address,
  value: BigInt,
  data: Bytes
): SubmitTransaction {
  let submitTransactionEvent = changetype<SubmitTransaction>(newMockEvent())

  submitTransactionEvent.parameters = new Array()

  submitTransactionEvent.parameters.push(
    new ethereum.EventParam("owner", ethereum.Value.fromAddress(owner))
  )
  submitTransactionEvent.parameters.push(
    new ethereum.EventParam(
      "txIndex",
      ethereum.Value.fromUnsignedBigInt(txIndex)
    )
  )
  submitTransactionEvent.parameters.push(
    new ethereum.EventParam("to", ethereum.Value.fromAddress(to))
  )
  submitTransactionEvent.parameters.push(
    new ethereum.EventParam("value", ethereum.Value.fromUnsignedBigInt(value))
  )
  submitTransactionEvent.parameters.push(
    new ethereum.EventParam("data", ethereum.Value.fromBytes(data))
  )

  return submitTransactionEvent
}

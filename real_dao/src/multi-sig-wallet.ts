import {
  ConfirmTransaction as ConfirmTransactionEvent,
  Deposit as DepositEvent,
  ExecuteTransaction as ExecuteTransactionEvent,
  RevokeConfirmation as RevokeConfirmationEvent,
  SubmitTransaction as SubmitTransactionEvent,
} from "../generated/MultiSigWallet/MultiSigWallet"
import {
  ConfirmTransaction,
  Deposit,
  ExecuteTransaction,
  RevokeConfirmation,
  SubmitTransaction,
} from "../generated/schema"

export function handleConfirmTransaction(event: ConfirmTransactionEvent): void {
  let entity = new ConfirmTransaction(
    event.transaction.hash.concatI32(event.logIndex.toI32()),
  )
  entity.owner = event.params.owner
  entity.txIndex = event.params.txIndex

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleDeposit(event: DepositEvent): void {
  let entity = new Deposit(
    event.transaction.hash.concatI32(event.logIndex.toI32()),
  )
  entity.sender = event.params.sender
  entity.amount = event.params.amount
  entity.balance = event.params.balance

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleExecuteTransaction(event: ExecuteTransactionEvent): void {
  let entity = new ExecuteTransaction(
    event.transaction.hash.concatI32(event.logIndex.toI32()),
  )
  entity.owner = event.params.owner
  entity.txIndex = event.params.txIndex

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleRevokeConfirmation(event: RevokeConfirmationEvent): void {
  let entity = new RevokeConfirmation(
    event.transaction.hash.concatI32(event.logIndex.toI32()),
  )
  entity.owner = event.params.owner
  entity.txIndex = event.params.txIndex

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleSubmitTransaction(event: SubmitTransactionEvent): void {
  let entity = new SubmitTransaction(
    event.transaction.hash.concatI32(event.logIndex.toI32()),
  )
  entity.owner = event.params.owner
  entity.txIndex = event.params.txIndex
  entity.to = event.params.to
  entity.value = event.params.value
  entity.data = event.params.data

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

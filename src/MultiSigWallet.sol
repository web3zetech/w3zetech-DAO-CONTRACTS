// SPDX-License-Identifier: MIT
// License identifier indicating that this contract uses the MIT License.

pragma solidity ^0.8.2;
// Specifies that the contract uses Solidity version 0.8.2 or later, but not breaking changes in future versions.

import "./Math.sol";
// Importing a Math library (assuming it has useful functions for performing math operations) that will be used in the contract.

contract MultiSigWallet {
    using Math for uint256;
    // This allows the use of functions from the Math library directly on uint256 types.

    // Events allow external applications to track and log key actions that occur in the contract.
    event Deposit(address indexed sender, uint256 amount, uint256 balance);
    // Triggered when funds are deposited into the wallet.

    event SubmitTransaction(
        address indexed owner,
        uint256 indexed txIndex,
        address indexed to,
        uint256 value,
        bytes data
    );
    // Triggered when an owner submits a new transaction.

    event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);
    // Triggered when an owner confirms a transaction.

    event RevokeConfirmation(address indexed owner, uint256 indexed txIndex);
    // Triggered when an owner revokes their confirmation on a transaction.

    event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);
    // Triggered when a transaction is successfully executed.

    // State variables to hold the wallet owners and the number of confirmations required for a transaction.
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public numConfirmationsRequired;

    // Structure to represent a Transaction.
    struct Transaction {
        address to;              // Recipient address
        uint256 value;           // Amount to be transferred
        bytes data;              // Transaction data (e.g., function calls)
        bool executed;           // Flag indicating whether the transaction has been executed
        uint256 numConfirmations; // Number of confirmations the transaction has received
    }

    // Mapping to track whether a specific owner has confirmed a specific transaction.
    mapping(uint256 => mapping(address => bool)) public isConfirmed;

    // Array to store all the transactions submitted to the wallet.
    Transaction[] public transactions;

    // Modifiers are used to add conditions to function executions.

    modifier onlyOwner() {
        // Modifier that allows only wallet owners to execute certain functions.
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    modifier txExists(uint256 _txIndex) {
        // Modifier to check if a transaction with a given index exists.
        require(_txIndex < transactions.length, "Transaction does not exist");
        _;
    }

    modifier notExecuted(uint256 _txIndex) {
        // Modifier to ensure that a transaction has not already been executed.
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }

    modifier notConfirmed(uint256 _txIndex) {
        // Modifier to ensure that the transaction has not already been confirmed by the owner calling the function.
        require(!isConfirmed[_txIndex][msg.sender], "Transaction already confirmed");
        _;
    }

    // Constructor to initialize the wallet with a list of owners and the number of confirmations required.
    constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
        require(_owners.length > 0, "Owners required");
        // Ensure at least one owner is specified.

        require(
            _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
            "Invalid number of confirmations required"
        );
        // Ensure the number of confirmations required is valid and not greater than the number of owners.

        // Loop through each owner, adding them to the owners array and marking them as valid owners.
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            // Ensure that the owner's address is valid.

            require(!isOwner[owner], "Owner not unique");
            // Ensure that the owner is unique and not already added.

            isOwner[owner] = true;
            owners.push(owner);
        }

        numConfirmationsRequired = _numConfirmationsRequired;
        // Set the required number of confirmations.
    }

    // Fallback function to allow the wallet to receive Ether.
    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
        // Trigger the Deposit event whenever Ether is sent to the contract.
    }

    // Function to submit a new transaction. Only owners can call this function.
    function submitTransaction(address _to, uint256 _value, bytes memory _data)
        public
        onlyOwner
    {
        uint256 txIndex = transactions.length;
        // The transaction index is the current length of the transactions array.

        transactions.push(
            Transaction({
                to: _to,               // Recipient address
                value: _value,         // Ether amount to be transferred
                data: _data,           // Transaction data (e.g., function calls)
                executed: false,       // Initially, the transaction is not executed
                numConfirmations: 0    // Initially, no confirmations are given
            })
        );
        // Add the new transaction to the transactions array.

        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
        // Emit the event for submitting the transaction.
    }

    // Function for owners to confirm a submitted transaction.
    function confirmTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        // Retrieve the transaction being confirmed.

        transaction.numConfirmations += 1;
        // Increment the number of confirmations for the transaction.

        isConfirmed[_txIndex][msg.sender] = true;
        // Mark that the owner has confirmed this transaction.

        emit ConfirmTransaction(msg.sender, _txIndex);
        // Emit the event to log the confirmation.
    }

    // Function to execute a transaction once it has enough confirmations.
    function executeTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        // Retrieve the transaction to be executed.

        require(
            transaction.numConfirmations >= numConfirmationsRequired,
            "Cannot execute transaction"
        );
        // Ensure the transaction has enough confirmations.

        transaction.executed = true;
        // Mark the transaction as executed.

        // Call the recipient's address with the transaction's value and data.
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "Transaction failed");
        // Ensure the transaction was successful.

        emit ExecuteTransaction(msg.sender, _txIndex);
        // Emit the event to log the execution.
    }

    // Function to revoke a previously given confirmation for a transaction.
    function revokeConfirmation(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        require(isConfirmed[_txIndex][msg.sender], "Transaction not confirmed");
        // Ensure the owner has previously confirmed this transaction.

        Transaction storage transaction = transactions[_txIndex];
        // Retrieve the transaction.

        transaction.numConfirmations -= 1;
        // Decrease the number of confirmations for the transaction.

        isConfirmed[_txIndex][msg.sender] = false;
        // Mark that the owner has revoked their confirmation.

        emit RevokeConfirmation(msg.sender, _txIndex);
        // Emit the event to log the revocation.
    }
}

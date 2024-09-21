// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

// Importing OpenZeppelin's Math library for secure mathematical operations
import "lib/openzeppelin-contracts/contracts/utils/math/Math.sol";

contract MultiSigWallet {
    // Using OpenZeppelin's Math library for uint256 type
    using Math for uint256;

    // Events to log important actions taken in the contract
    event Deposit(address indexed sender, uint256 amount, uint256 balance); // Log deposits to the wallet
    event SubmitTransaction( // Log when a transaction is submitted
        address indexed owner,
        uint256 indexed txIndex,
        address indexed to,
        uint256 value,
        bytes data
    );
    event ConfirmTransaction(address indexed owner, uint256 indexed txIndex); // Log when a transaction is confirmed by an owner
    event RevokeConfirmation(address indexed owner, uint256 indexed txIndex); // Log when an owner revokes their confirmation
    event ExecuteTransaction(address indexed owner, uint256 indexed txIndex); // Log when a transaction is successfully executed

    // State variables
    address[] public owners; // Array of owner addresses
    mapping(address => bool) public isOwner; // Mapping to check if an address is an owner
    uint256 public numConfirmationsRequired; // Number of confirmations required to execute a transaction

    // Data structure to store a transaction's details
    struct Transaction {
        address to; // The address to send funds to
        uint256 value; // The amount of funds to send
        bytes data; // Additional transaction data (e.g., for calling a function on another contract)
        bool executed; // Whether the transaction has been executed
        uint256 numConfirmations; // Number of confirmations this transaction has received
    }

    // Mapping from transaction index to a mapping of owner confirmations
    mapping(uint256 => mapping(address => bool)) public isConfirmed;

    // Array to hold all submitted transactions
    Transaction[] public transactions;

    // Modifiers to limit access to certain functions

    // Modifier to ensure only owners can call the function
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner"); // Check if the caller is an owner
        _;
    }

    // Modifier to ensure the transaction exists
    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "Transaction does not exist"); // Check if the transaction index is valid
        _;
    }

    // Modifier to ensure the transaction hasn't been executed yet
    modifier notExecuted(uint256 _txIndex) {
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }

    // Modifier to ensure the transaction hasn't already been confirmed by the caller
    modifier notConfirmed(uint256 _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "Transaction already confirmed");
        _;
    }

    // Constructor to initialize the contract with a list of owners and the number of confirmations required for transactions
    constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
        require(_owners.length > 0, "Owners required"); // Ensure there is at least one owner
        require(
            _numConfirmationsRequired > 0 &&
            _numConfirmationsRequired <= _owners.length,
            "Invalid number of confirmations required"
        );

        // Loop through the owners and add them to the contract's state
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner"); // Ensure the owner address is valid (not 0x0)
            require(!isOwner[owner], "Owner not unique"); // Ensure each owner is unique

            isOwner[owner] = true; // Mark the address as an owner
            owners.push(owner); // Add the owner to the owners array
        }

        numConfirmationsRequired = _numConfirmationsRequired; // Set the required number of confirmations
    }

    // Fallback function to accept Ether deposits to the contract
    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance); // Emit deposit event
    }

    // Function to submit a transaction. Can only be called by an owner
    function submitTransaction(address _to, uint256 _value, bytes memory _data)
        public
        onlyOwner
    {
        uint256 txIndex = transactions.length; // Get the next transaction index

        // Add the transaction to the transactions array
        transactions.push(
            Transaction({
                to: _to, // The recipient of the transaction
                value: _value, // The value (amount of Ether) to send
                data: _data, // Optional data to include with the transaction
                executed: false, // Transaction starts as not executed
                numConfirmations: 0 // No confirmations yet
            })
        );

        // Emit an event for the submitted transaction
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    // Function to confirm a transaction. Can only be called by an owner
    function confirmTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex]; // Get the transaction details
        transaction.numConfirmations += 1; // Increase the number of confirmations
        isConfirmed[_txIndex][msg.sender] = true; // Mark the transaction as confirmed by the owner

        // Emit an event for the confirmation
        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    // Function to execute a confirmed transaction. Uses Check-Effects-Interactions pattern
    function executeTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex]; // Get the transaction details

        // **CHECK**: Ensure the transaction has enough confirmations before executing
        require(
            transaction.numConfirmations >= numConfirmationsRequired,
            "Cannot execute transaction"
        );

        // **EFFECTS**: Mark the transaction as executed before making any external calls
        transaction.executed = true;

        // **INTERACTIONS**: Interact with the external address by calling the transaction
        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "Transaction failed"); // Ensure the transaction succeeds

        // Emit an event for the executed transaction
        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    // Function to revoke a confirmation for a transaction. Can only be called by an owner
    function revokeConfirmation(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        require(isConfirmed[_txIndex][msg.sender], "Transaction not confirmed"); // Ensure the transaction was already confirmed by the owner

        Transaction storage transaction = transactions[_txIndex]; // Get the transaction details
        transaction.numConfirmations -= 1; // Decrease the number of confirmations
        isConfirmed[_txIndex][msg.sender] = false; // Revoke the confirmation

        // Emit an event for the revoked confirmation
        emit RevokeConfirmation(msg.sender, _txIndex);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

// Import the ERC20 interface for the w3z token
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/utils/math/Math.sol";

contract MultiSigWallet {
    using Math for uint256;  // Use OpenZeppelin's Math library for safe mathematical operations

    IERC20 public w3zToken;  // Reference to the w3z token contract, used for token transfers

    // Events for logging important actions like deposits and transaction-related events
    event Deposit(address indexed sender, uint256 amount, uint256 balance);  // Event triggered when tokens are deposited
    event SubmitTransaction(
        address indexed owner,
        uint256 indexed txIndex,
        address indexed to,
        uint256 value,
        bytes data
    );  // Event triggered when a transaction is submitted
    event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);  // Event triggered when a transaction is confirmed
    event RevokeConfirmation(address indexed owner, uint256 indexed txIndex);  // Event triggered when a confirmation is revoked
    event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);  // Event triggered when a transaction is executed

    // State variables
    address[] public owners;  // Array of wallet owners
    mapping(address => bool) public isOwner;  // Mapping to track which addresses are owners
    uint256 public numConfirmationsRequired;  // Minimum number of confirmations required for a transaction
    bool public isInitialized;  // Flag to check if the wallet has been initialized

    struct Transaction {
        address to;  // Address to send tokens to
        uint256 value;  // Amount of w3z tokens to send
        bytes data;  // Optional transaction data (for contract interactions)
        bool executed;  // Status of whether the transaction has been executed
        uint256 numConfirmations;  // Number of confirmations received for the transaction
    }

    // Mapping to track if a transaction has been confirmed by an owner
    mapping(uint256 => mapping(address => bool)) public isConfirmed;
    Transaction[] public transactions;  // Array to store all submitted transactions

    // Modifiers to restrict access and ensure certain conditions are met

    // Ensure the caller is an owner of the multisig wallet
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    // Ensure the transaction exists
    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "Transaction does not exist");
        _;
    }

    // Ensure the transaction has not already been executed
    modifier notExecuted(uint256 _txIndex) {
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }

    // Ensure the transaction has not already been confirmed by the caller
    modifier notConfirmed(uint256 _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "Transaction already confirmed");
        _;
    }

    // Ensure that the wallet has not already been initialized
    modifier onlyWhenNotInitialized() {
        require(!isInitialized, "Already initialized");
        _;
    }

    // Constructor without any parameters; initialization will be done later via `initialize`
    constructor() {}

    // Function to initialize the multisig wallet with owners, number of confirmations, and the w3z token
    // Can only be called once
    function initialize(
        address[] memory _owners,
        uint256 _numConfirmationsRequired,
        IERC20 _w3zToken
    ) public onlyWhenNotInitialized {
        require(_owners.length > 0, "Owners required");  // Ensure there is at least one owner
        require(
            _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
            "Invalid number of confirmations required"
        );  // Ensure valid number of confirmations

        // Set up the owners and ensure they are unique
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");  // Ensure valid owner address
            require(!isOwner[owner], "Owner not unique");  // Ensure no duplicate owners

            isOwner[owner] = true;  // Mark the address as an owner
            owners.push(owner);  // Add the owner to the owners array
        }

        numConfirmationsRequired = _numConfirmationsRequired;  // Set the required number of confirmations
        w3zToken = _w3zToken;  // Assign the w3z token contract instance
        isInitialized = true;  // Mark the contract as initialized
    }

    // Function to allow deposits of w3z tokens into the multisig wallet
    function deposit(uint256 _amount) external {
        require(w3zToken.transferFrom(msg.sender, address(this), _amount), "Transfer failed");  // Transfer tokens to the wallet
        emit Deposit(msg.sender, _amount, w3zToken.balanceOf(address(this)));  // Log the deposit
    }

    // Function to submit a new transaction
    function submitTransaction(address _to, uint256 _value, bytes memory _data)
        public
        onlyOwner
    {
        uint256 txIndex = transactions.length;  // Get the next transaction index

        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            numConfirmations: 0
        }));

        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);  // Log the submitted transaction
    }

    // Function to confirm a transaction
    function confirmTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];  // Fetch the transaction
        transaction.numConfirmations += 1;  // Increment the number of confirmations
        isConfirmed[_txIndex][msg.sender] = true;  // Mark the transaction as confirmed by this owner

        emit ConfirmTransaction(msg.sender, _txIndex);  // Log the confirmation
    }

    // Function to execute a transaction once enough confirmations are received
    function executeTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];  // Fetch the transaction

        // Ensure the transaction has enough confirmations before executing
        require(transaction.numConfirmations >= numConfirmationsRequired, "Cannot execute transaction");

        transaction.executed = true;  // Mark the transaction as executed

        // Transfer w3z tokens to the recipient
        require(w3zToken.transfer(transaction.to, transaction.value), "Token transfer failed");

        emit ExecuteTransaction(msg.sender, _txIndex);  // Log the transaction execution
    }

    // Function to revoke a confirmation for a transaction
    function revokeConfirmation(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        require(isConfirmed[_txIndex][msg.sender], "Transaction not confirmed");  // Ensure the transaction is confirmed

        Transaction storage transaction = transactions[_txIndex];  // Fetch the transaction
        transaction.numConfirmations -= 1;  // Decrement the number of confirmations
        isConfirmed[_txIndex][msg.sender] = false;  // Mark the transaction as no longer confirmed by this owner

        emit RevokeConfirmation(msg.sender, _txIndex);  // Log the confirmation revocation
    }
}

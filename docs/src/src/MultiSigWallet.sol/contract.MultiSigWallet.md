# MultiSigWallet
[Git Source](https://github.com/web3zetech/w3zetech-dao/blob/238d69f4fab39e40c6d1a6576d7ac2a425c9ae43/src/MultiSigWallet.sol)


## State Variables
### owners

```solidity
address[] public owners;
```


### isOwner

```solidity
mapping(address => bool) public isOwner;
```


### numConfirmationsRequired

```solidity
uint256 public numConfirmationsRequired;
```


### isConfirmed

```solidity
mapping(uint256 => mapping(address => bool)) public isConfirmed;
```


### transactions

```solidity
Transaction[] public transactions;
```


## Functions
### onlyOwner


```solidity
modifier onlyOwner();
```

### txExists


```solidity
modifier txExists(uint256 _txIndex);
```

### notExecuted


```solidity
modifier notExecuted(uint256 _txIndex);
```

### notConfirmed


```solidity
modifier notConfirmed(uint256 _txIndex);
```

### constructor


```solidity
constructor(address[] memory _owners, uint256 _numConfirmationsRequired);
```

### receive


```solidity
receive() external payable;
```

### submitTransaction


```solidity
function submitTransaction(address _to, uint256 _value, bytes memory _data) public onlyOwner;
```

### confirmTransaction


```solidity
function confirmTransaction(uint256 _txIndex)
    public
    onlyOwner
    txExists(_txIndex)
    notExecuted(_txIndex)
    notConfirmed(_txIndex);
```

### executeTransaction


```solidity
function executeTransaction(uint256 _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex);
```

### revokeConfirmation


```solidity
function revokeConfirmation(uint256 _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex);
```

## Events
### Deposit

```solidity
event Deposit(address indexed sender, uint256 amount, uint256 balance);
```

### SubmitTransaction

```solidity
event SubmitTransaction(address indexed owner, uint256 indexed txIndex, address indexed to, uint256 value, bytes data);
```

### ConfirmTransaction

```solidity
event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);
```

### RevokeConfirmation

```solidity
event RevokeConfirmation(address indexed owner, uint256 indexed txIndex);
```

### ExecuteTransaction

```solidity
event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);
```

## Structs
### Transaction

```solidity
struct Transaction {
    address to;
    uint256 value;
    bytes data;
    bool executed;
    uint256 numConfirmations;
}
```


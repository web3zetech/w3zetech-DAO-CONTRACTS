# MainDAOContract
[Git Source](https://github.com/web3zetech/w3zetech-dao/blob/238d69f4fab39e40c6d1a6576d7ac2a425c9ae43/src/MAINDAOContract.sol)


## State Variables
### token

```solidity
w3zetechToken public token;
```


### multiSigWallet

```solidity
MultiSigWallet public multiSigWallet;
```


### dao

```solidity
DAO public dao;
```


## Functions
### constructor


```solidity
constructor(address[] memory _multiSigOwners, uint256 _numConfirmationsRequired);
```


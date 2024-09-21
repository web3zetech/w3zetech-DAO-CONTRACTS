# w3zetechToken
[Git Source](https://github.com/web3zetech/w3zetech-dao/blob/238d69f4fab39e40c6d1a6576d7ac2a425c9ae43/src/w3zetechToken.sol)

**Inherits:**
ERC20, Ownable


## State Variables
### initialSupply

```solidity
uint256 public initialSupply = 1000000000 * 10 ** decimals();
```


## Functions
### constructor


```solidity
constructor() ERC20("w3zetech", "W3Z") Ownable(msg.sender);
```


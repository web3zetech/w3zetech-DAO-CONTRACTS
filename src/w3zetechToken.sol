// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
// This line imports the ERC20 token standard contract from OpenZeppelin's library.
// ERC20 is a standard for creating fungible tokens on the Ethereum blockchain.

import "openzeppelin-contracts/contracts/access/Ownable.sol";
// This line imports the Ownable contract from OpenZeppelin's library.
// Ownable is a contract that provides a basic access control mechanism, where a single account (the "owner") has elevated permissions.

contract w3zetechToken is ERC20, Ownable {
    // This line declares a new contract called w3zetechToken, which inherits from both ERC20 and Ownable.

    uint256 public initialSupply = 1000000000 * 10 ** decimals();
    // This line declares a public variable initialSupply, which represents the initial supply of tokens.
    // The initial supply is set to 1,000,000,000 tokens, taking into account the decimal places of the token.

    constructor() ERC20("w3zetech", "W3Z") Ownable(msg.sender) {
        // This is the constructor function, which is called when the contract is deployed.
        // It initializes the ERC20 token with the name "w3zetech" and symbol "W3ZETECH".
        // It also sets the owner of the contract to the account that deployed it (msg.sender).

        _mint(msg.sender, initialSupply);
        // This line mints the initial supply of tokens to the owner's account (msg.sender).
    }
}
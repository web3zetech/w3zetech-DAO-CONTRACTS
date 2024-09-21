// SPDX-License-Identifier: MIT
// This line specifies the license under which the contract is released.

pragma solidity 0.8.27;
// This line specifies the version of the Solidity compiler to use.

import "./w3zetechToken.sol";
// This line imports the w3zetechToken contract, which is likely a custom ERC-20 token.

import "./MultiSigWallet.sol";
// This line imports the MultiSigWallet contract, which is a multi-signature wallet that requires a certain number of signers to approve transactions.

import "./DAO.sol";
// This line imports the DAO contract, which is a decentralized autonomous organization that makes decisions based on token holder votes.

contract MainDAOContract {
    // This contract is the main entry point for the DAO.

    w3zetechToken public token;
    // This variable stores an instance of the w3zetechToken contract, which is deployed in the constructor.

    MultiSigWallet public multiSigWallet;
    // This variable stores an instance of the MultiSigWallet contract, which is deployed in the constructor.

    DAO public dao;
    // This variable stores an instance of the DAO contract, which is deployed in the constructor.

    constructor(
        address[] memory _multiSigOwners,
        uint256 _numConfirmationsRequired
    ) {
        // This is the constructor function, which is called when the contract is deployed.

        // Deploy the governance token
        token = new w3zetechToken();
        // This line deploys a new instance of the w3zetechToken contract.

        // Deploy the multi-signature wallet with 5 of 7 required signers
        multiSigWallet = new MultiSigWallet(_multiSigOwners, _numConfirmationsRequired);
        // This line deploys a new instance of the MultiSigWallet contract, passing in the list of owners and the required number of confirmations.

        // Deploy the DAO
        dao = new DAO(token);
        // This line deploys a new instance of the DAO contract, passing in the deployed token contract.
    }
}
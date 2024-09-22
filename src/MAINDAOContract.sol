// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "./w3zetechToken.sol";
import "./MultiSigWallet.sol";
import "./DAO.sol";

contract MainDAOContract {
    w3zetechToken public token;  // Instance of the w3zetechToken contract
    MultiSigWallet public multiSigWallet;  // Instance of the MultiSigWallet contract
    DAO public dao;  // Instance of the DAO contract

    constructor() {
        // Deploy the governance token
        token = new w3zetechToken();

        // Deploy the MultiSigWallet contract without parameters (initialize later)
        multiSigWallet = new MultiSigWallet();

        // Deploy the DAO and pass the w3zetech token to it
        dao = new DAO(token);
    }

    // Function to initialize the MultiSigWallet after deployment
    function initializeMultiSigWallet(
        address[] memory _multiSigOwners,
        uint256 _numConfirmationsRequired
    ) public {
        // Initialize the multisig wallet with owners, confirmations, and the token
        multiSigWallet.initialize(_multiSigOwners, _numConfirmationsRequired, token);
    }
}

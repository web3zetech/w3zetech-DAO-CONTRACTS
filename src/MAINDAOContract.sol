// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./w3zetechToken.sol";
import "./MultiSigWallet.sol";
import "./DAO.sol";

contract MainDAOContract {
    w3zetechToken public token;
    MultiSigWallet public multiSigWallet;
    DAO public dao;

    constructor(
        address[] memory _multiSigOwners,
        uint256 _numConfirmationsRequired
    ) {
        // Deploy the governance token
        token = new w3zetechToken();

        // Deploy the multi-signature wallet with 5 of 7 required signers
        multiSigWallet = new MultiSigWallet(_multiSigOwners, _numConfirmationsRequired);

        // Deploy the DAO
        dao = new DAO(token);
    }
}

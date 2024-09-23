# W3Zetech DAO

## Project Description  
**W3Zetech DAO** is a student-led decentralized autonomous organization (DAO) focused on promoting web3 and blockchain education while providing a platform for active governance. Built on the **Base Sepolia** blockchain, W3Zetech DAO empowers its members to propose, vote, and execute decisions about the future of the community using the **W3Zetech token (W3Z)**. The DAO manages its treasury via a multi-signature wallet, ensuring secure, transparent, and community-driven fund allocation. 

W3Zetech DAO leverages **The Graph** to offer real-time data on governance activities, allowing for a seamless and transparent on-chain experience. Members can easily track proposals, votes, and token purchases, while ensuring all decisions are executed fairly and securely through smart contracts.

**Verified _Smart_Contracts_Addresses**

```
w3zetechTokenAddress: 0xD818e3AD00F322ebb2A3659A09c1d44C5C447011
DAOcontractAddress:  0x51632D52aa0b31EeF31D80DAa9DA1bCf2724D53C
MultiSigContractAddress: 0xbAB4a9cF91D802c053f05B96f809b4D98F3c0D54

```


**Mission:**  
W3Zetech aims to create a decentralized ecosystem where members actively participate in governance and resource management while learning about blockchain technology.

## Features  
- **W3Zetech Token (W3Z):**  
  A governance token with a fixed supply of 1 billion tokens. The token powers the voting mechanism and represents a member’s stake and voice in the DAO.

- **On-Chain Governance:**  
  Members can submit proposals, vote on critical decisions, and manage community initiatives on-chain. Each W3Z token represents one vote, making the decision-making process both transparent and decentralized.

- **Multi-Signature Wallet:**  
  The DAO’s treasury is secured via a multi-signature wallet, requiring approval from multiple signers for any transaction. This ensures secure and community-driven fund management.

- **Real-Time Data Integration:**  
  Using **The Graph**, we provide real-time querying of on-chain events such as proposal submissions, votes, and fund disbursement, enhancing transparency.

- **Decentralized Fund Allocation:**  
  Funds raised or managed by the DAO are stored in the treasury and can only be distributed through community-approved proposals. All fund movements are secured by the multi-signature wallet, reducing the risk of mismanagement.

## Installation Instructions  

### Prerequisites  
- **Node.js** and **npm** for project setup and development.
- **MetaMask** or other Web3 wallets for blockchain interaction.
- **foundry** for smart contract development, testing, and deployment.
- **The Graph** for data querying (optional but recommended).

### Steps to Set Up Locally

1. **Clone the repository:**
    ```bash
    git clone https://github.com/web3zetech/w3zetech-dao
    cd w3zetech-dao
    ```

2. **Install the necessary dependencies:**
    ```bash
    npm install
    ```

3. **Compile the smart contracts:**
    ```bash
    forge build
    ```

4. **Deploy contracts to a local testnet (e.g., Sepolia):**
    ```bash
    forge create --rpc-url <RPS-URL>--private-key <PRIVATE_KEY> src/MyContract.sol:MyContract

    ```

5. **Deploy and configure The Graph for real-time data querying:**
    Follow the setup instructions on [The Graph Documentation](https://thegraph.com/docs/en/quick-start/).


## Usage Instructions  

### Interaction with the DAO  
Once the smart contracts are deployed, users can interact with the DAO via a web-based frontend or using Web3 wallets like MetaMask.

### Example Scenarios:
- **Voting on a Proposal:**
  1. Connect your wallet to the DApp using MetaMask.
  2. View the list of active proposals.
  3. Select a proposal and cast your vote (Yes/No) based on your W3Z token balance.

- **Creating a Proposal:**
  1. Navigate to the "Create Proposal" section.
  2. Provide the details for your proposal (e.g., fund allocation or community initiatives).
  3. Submit the proposal, which will be put up for voting by the community.

- **Managing the DAO Treasury:**
  1. Access the treasury management section via the multi-signature wallet.
  2. Submit a request for fund withdrawal or project funding.
  3. Other signers in the DAO will review and confirm the transaction.
  4. Once the required number of approvals is reached, the funds will be released.

### Developer Usage
Developers can interact directly with the deployed smart contracts for testing or automation purposes. Here are some common interactions:

- **Submitting a Proposal Programmatically:**
    ```js
    const daoContract = new ethers.Contract(daoAddress, daoABI, signer);
    const tx = await daoContract.createProposal("Proposal description");
    await tx.wait();
    ```

- **Confirming a Multi-Sig Transaction:**
    ```js
    const walletContract = new ethers.Contract(walletAddress, walletABI, signer);
    const tx = await walletContract.confirmTransaction(transactionId);
    await tx.wait();
    ```

## Contributing Guidelines  
We welcome contributions to improve W3Zetech DAO! Whether you're adding new features, fixing bugs, or improving documentation, we’d love your help.

### Steps to Contribute:
1. **Fork the repository.**
2. **Create a new branch:**
    ```bash
    git checkout -b feature/YourFeature
    ```
3. **Commit your changes:**
    ```bash
    git commit -m 'Add new feature'
    ```
4. **Push to the branch:**
    ```bash
    git push origin feature/YourFeature
    ```
5. **Submit a pull request** with a detailed description of your changes.

### Code of Conduct  
We follow a code of conduct that promotes inclusivity and respect. Be kind, respectful, and supportive of others. Constructive feedback and collaboration are key principles.

## License Information  
This project is licensed under the **MIT License**. You're free to use, modify, and distribute the code as long as proper credit is given to the original authors.

## Contact Information  
For any inquiries, suggestions, or issues, please feel free to reach out:

- **Email:** w3zetech@gmail.com
- **GitHub Issues:** [Report an issue](https://github.com/web3zetech/w3zetech-dao/issues)
- **Website:** [####](http://w3zetechdao.org)

---

## Additional Information

### Unique Aspects of W3Zetech DAO:
- **Educational Focus:** Unlike other DAOs, W3Zetech is rooted in student initiatives, aiming to provide hands-on experience with blockchain and decentralized governance.
- **Real-Time Transparency:** The integration of **The Graph** ensures that all activities, from proposal submissions to fund disbursement, are transparently tracked and accessible in real time.
- **Treasury Security:** The multi-signature wallet ensures that all fund-related actions require consensus from multiple trusted members, reducing the risk of fraud or mismanagement.
- **Community Growth:** By empowering members to take part in decision-making processes, W3Zetech DAO fosters an engaged and educated community that actively drives its development.

---

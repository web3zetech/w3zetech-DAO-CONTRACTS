// SPDX-License-Identifier: MIT
// License identifier indicating that this contract uses the MIT License.

pragma solidity ^0.8.2;
// This specifies the Solidity version. ^0.8.2 means compatible with any version 0.8.x, but not earlier versions.

import "./w3zetechToken.sol";
// Importing the w3zetechToken contract, which represents the governance token for voting and DAO interactions.

contract DAO {
    // State variable to hold the governance token contract instance (for voting power).
    w3zetechToken public governanceToken;
    
    // Duration for voting on proposals.
    uint256 public votingDuration = 5 days;

    // Delay before proposals can be executed after the voting period ends.
    uint256 public executionDelay = 2 days;

    // Minimum quorum (10%) of the total supply required for a proposal to pass.
    uint256 public quorum = 10;

    // Structure defining a Proposal. Each proposal contains:
    // - proposer: Address of the person who created the proposal.
    // - description: A string describing the proposal.
    // - voteCount: Number of votes the proposal has received.
    // - deadline: The timestamp when the voting ends.
    // - executed: Whether the proposal has been executed or not.
    // - passed: Whether the proposal passed or not (based on the quorum).
    struct Proposal {
        address proposer;
        string description;
        uint256 voteCount;
        uint256 deadline;
        bool executed;
        bool passed;
    }

    // Array to hold all proposals made by the DAO members.
    Proposal[] public proposals;

    // Mapping to track if a user has already voted on a specific proposal.
    // The first uint256 is the proposalId, and the address represents the voter's address.
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    // Event emitted when a new proposal is created.
    event ProposalCreated(uint256 proposalId, address proposer, string description);
    
    // Event emitted when a vote is cast on a proposal.
    event Voted(uint256 proposalId, address voter, uint256 votes);
    
    // Event emitted when a proposal is executed.
    event ProposalExecuted(uint256 proposalId, bool passed);

    // Constructor to set the governance token when the DAO contract is deployed.
    constructor(w3zetechToken _governanceToken) {
        governanceToken = _governanceToken;
    }

    // Function to create a new proposal. Only external accounts can call this function.
    // The function takes a description of the proposal and sets up a new Proposal struct.
    function createProposal(string memory _description) external {
        // Creating a new proposal with the proposer as the sender.
        Proposal memory newProposal = Proposal({
            proposer: msg.sender,
            description: _description,
            voteCount: 0,
            deadline: block.timestamp + votingDuration, // Voting deadline set to the current time + voting duration.
            executed: false,
            passed: false
        });

        // Adding the new proposal to the proposals array.
        proposals.push(newProposal);

        // Emitting an event to notify that a new proposal was created.
        emit ProposalCreated(proposals.length - 1, msg.sender, _description);
    }

    // Function for members to vote on a specific proposal.
    // `_proposalId` refers to the index of the proposal in the proposals array.
    function voteOnProposal(uint256 _proposalId) external {
        // Accessing the specific proposal from the proposals array.
        Proposal storage proposal = proposals[_proposalId];

        // Ensure the current time is before the voting deadline.
        require(block.timestamp <= proposal.deadline, "Voting period has ended");

        // Ensure that the voter has not already voted on this proposal.
        require(!hasVoted[_proposalId][msg.sender], "You have already voted");

        // Getting the voter's governance token balance (i.e., voting power).
        uint256 voterBalance = governanceToken.balanceOf(msg.sender);

        // Adding the voter's balance to the proposal's total vote count.
        proposal.voteCount += voterBalance;

        // Marking the voter as having voted on this proposal.
        hasVoted[_proposalId][msg.sender] = true;

        // Emitting an event to log the vote.
        emit Voted(_proposalId, msg.sender, voterBalance);
    }

    // Function to execute a proposal once the voting period has ended.
    // A proposal can only be executed after the execution delay has passed.
    function executeProposal(uint256 _proposalId) external {
        // Accessing the specific proposal to be executed.
        Proposal storage proposal = proposals[_proposalId];

        // Ensure that enough time has passed since the voting deadline to allow execution.
        require(block.timestamp >= proposal.deadline + executionDelay, "Execution delay has not passed");

        // Ensure that the proposal hasn't already been executed.
        require(!proposal.executed, "Proposal already executed");

        // Fetching the total supply of governance tokens to calculate the quorum.
        uint256 totalSupply = governanceToken.totalSupply();

        // Check if the proposal reached the quorum (e.g., if votes meet or exceed the required 10%).
        if (proposal.voteCount >= totalSupply * quorum / 100) {
            proposal.passed = true; // Mark the proposal as passed.
        }

        // Marking the proposal as executed.
        proposal.executed = true;

        // Emitting an event to log that the proposal was executed and whether it passed.
        emit ProposalExecuted(_proposalId, proposal.passed);
    }

    // Function to check the membership tier of a given member based on their token holdings.
    // Membership tiers are Platinum, Gold, Silver, and Basic depending on the token balance.
    function checkMembershipTier(address _member) external view returns (string memory) {
        // Fetching the token balance of the member.
        uint256 balance = governanceToken.balanceOf(_member);

        // Determining the membership tier based on the balance of governance tokens.
        if (balance >= 1000000 * 10 ** governanceToken.decimals()) {
            return "Platinum"; // Highest tier
        } else if (balance >= 500000 * 10 ** governanceToken.decimals()) {
            return "Gold"; // Mid-tier
        } else if (balance >= 100000 * 10 ** governanceToken.decimals()) {
            return "Silver"; // Lower-tier
        } else {
            return "Basic"; // Basic membership for small or no holdings.
        }
    }
}

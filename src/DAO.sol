// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./w3zetechToken.sol";

contract DAO {
    w3zetechToken public governanceToken;
    uint256 public votingDuration = 5 days;
    uint256 public executionDelay = 2 days;
    uint256 public quorum = 10; // 10% of total supply

    struct Proposal {
        address proposer;
        string description;
        uint256 voteCount;
        uint256 deadline;
        bool executed;
        bool passed;
    }

    Proposal[] public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint256 proposalId, address proposer, string description);
    event Voted(uint256 proposalId, address voter, uint256 votes);
    event ProposalExecuted(uint256 proposalId, bool passed);

    constructor(w3zetechToken _governanceToken) {
        governanceToken = _governanceToken;
    }

    function createProposal(string memory _description) external {
        Proposal memory newProposal = Proposal({
            proposer: msg.sender,
            description: _description,
            voteCount: 0,
            deadline: block.timestamp + votingDuration,
            executed: false,
            passed: false
        });

        proposals.push(newProposal);
        emit ProposalCreated(proposals.length - 1, msg.sender, _description);
    }

    function voteOnProposal(uint256 _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp <= proposal.deadline, "Voting period has ended");
        require(!hasVoted[_proposalId][msg.sender], "You have already voted");

        uint256 voterBalance = governanceToken.balanceOf(msg.sender);
        proposal.voteCount += voterBalance;
        hasVoted[_proposalId][msg.sender] = true;
        emit Voted(_proposalId, msg.sender, voterBalance);
    }

    function executeProposal(uint256 _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.deadline + executionDelay, "Execution delay has not passed");
        require(!proposal.executed, "Proposal already executed");

        uint256 totalSupply = governanceToken.totalSupply();
        if (proposal.voteCount >= totalSupply * quorum / 100) {
            proposal.passed = true;
        }

        proposal.executed = true;
        emit ProposalExecuted(_proposalId, proposal.passed);
    }

    function checkMembershipTier(address _member) external view returns (string memory) {
        uint256 balance = governanceToken.balanceOf(_member);
        if (balance >= 1000000 * 10 ** governanceToken.decimals()) {
            return "Platinum";
        } else if (balance >= 500000 * 10 ** governanceToken.decimals()) {
            return "Gold";
        } else if (balance >= 100000 * 10 ** governanceToken.decimals()) {
            return "Silver";
        } else {
            return "Basic";
        }
    }
}

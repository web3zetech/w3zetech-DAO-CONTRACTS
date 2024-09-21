# DAO
[Git Source](https://github.com/web3zetech/w3zetech-dao/blob/238d69f4fab39e40c6d1a6576d7ac2a425c9ae43/src/DAO.sol)


## State Variables
### governanceToken

```solidity
w3zetechToken public governanceToken;
```


### votingDuration

```solidity
uint256 public votingDuration = 5 days;
```


### executionDelay

```solidity
uint256 public executionDelay = 2 days;
```


### quorum

```solidity
uint256 public quorum = 10;
```


### proposals

```solidity
Proposal[] public proposals;
```


### hasVoted

```solidity
mapping(uint256 => mapping(address => bool)) public hasVoted;
```


## Functions
### constructor


```solidity
constructor(w3zetechToken _governanceToken);
```

### createProposal


```solidity
function createProposal(string memory _description) external;
```

### voteOnProposal


```solidity
function voteOnProposal(uint256 _proposalId) external;
```

### executeProposal


```solidity
function executeProposal(uint256 _proposalId) external;
```

### checkMembershipTier


```solidity
function checkMembershipTier(address _member) external view returns (string memory);
```

## Events
### ProposalCreated

```solidity
event ProposalCreated(uint256 proposalId, address proposer, string description);
```

### Voted

```solidity
event Voted(uint256 proposalId, address voter, uint256 votes);
```

### ProposalExecuted

```solidity
event ProposalExecuted(uint256 proposalId, bool passed);
```

## Structs
### Proposal

```solidity
struct Proposal {
    address proposer;
    string description;
    uint256 voteCount;
    uint256 deadline;
    bool executed;
    bool passed;
}
```


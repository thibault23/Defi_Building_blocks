pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract DAO {
  enum Side {Yes, No}
  enum Status {Undecided, Approved, Rejected}
  struct Proposal {
    address proposal;
    bytes32 hash;
    uint createdAt;
    uint voteYes;
    uint voteNo;
    Status status;
  }

  mapping(bytes32 => Proposal) public proposals;
  mapping(address => mapping(bytes32 => bool)) public votes;
  mapping(address => uint) public shares;
  uint public totalShares;
  IERC20 public token;
  uint constant CREATE_PROPOSAL_MIN_SHARE = 1000 * 10 * 18;
  uint constant VOTING_PERIOD = 7 days;

  constructor (address _token) {
    token = IERC20(_token);
  }

  function deposit(uint _shares) external {
    shares[msg.sender] += _shares;
    totalShares += _shares;
    token.transferFrom(msg.sender, address(this), _shares);
  }

  function withdraw(uint _shares) external {
    require(shares[msg.sender] >= _shares, 'not enough shares to withdraw');
    shares[msg.sender] -= _shares;
    totalShares -= _shares;
    token.transfer(msg.sender, _shares);
  }

  function createProposal(bytes32 _proposal) external {
    require(shares[msg.sender] >= CREATE_PROPOSAL_MIN_SHARE, 'not enough shares to create a proposal');
    require(proposals[_proposal].hash == bytes32(0), 'proposal already created');
    proposals[_proposal] = Proposal(
      msg.sender,
      _proposal,
      block.timestamp,
      0,
      0,
      Status.Undecided
      );
  }

  function vote(bytes32 _proposal, Side _side) external {
    //Proposal storage proposal = proposals[_proposal];
    require(proposals[_proposal].hash != bytes32(0), 'proposal does not exist');
    require(shares[msg.sender] != 0, 'no shares to vote with');
    require(votes[msg.sender][_proposal] == false, 'already voted');
    require(proposals[_proposal].createdAt + VOTING_PERIOD >= block.timestamp, 'voting period ended');
    votes[msg.sender][_proposal] = true;
    if(_side == Side.Yes)
    {
      proposals[_proposal].voteYes += shares[msg.sender];
      if(proposals[_proposal].voteYes * 100 / totalShares > 50) {
        proposals[_proposal].status = Status.Approved;
      }
    } else {
      proposals[_proposal].voteNo += shares[msg.sender];
      if(proposals[_proposal].voteNo * 100 / totalShares > 50) {
        proposals[_proposal].status = Status.Rejected;
      }
    }
  }
}

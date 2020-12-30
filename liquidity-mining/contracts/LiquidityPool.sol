pragma solidity ^0.7.3;

import './UnderlyingToken.sol';
import './LpToken.sol';
import './GovernanceToken.sol';

contract LiquidityPool is LpToken {
  //to calculate rewards, reference to distribute the governance token
  mapping(address => uint) public checkpoints;
  UnderlyingToken public underlyingToken;
  GovernanceToken public governanceToken;
  uint constant public REWARD_PER_BLOCK = 1;

  constructor(address _underlyingToken, address _governanceToken) {
    underlyingToken = UnderlyingToken(_underlyingToken);
    governanceToken = GovernanceToken(_governanceToken);
  }

  function deposit(uint amount) external {
    if(checkpoints[msg.sender] == 0) {
      checkpoints[msg.sender] = block.number;
    }

    _distributeRewards(msg.sender);
    underlyingToken.transferFrom(msg.sender, address(this), amount);
    _mint(msg.sender, amount); //mint function of the lptoken  1 to 1!
  }

  //amount of lptoken, not underlying token attention!
  function withdraw(uint amount) external {
    require(balanceOf(msg.sender) >= amount, 'not enough LP tokens');
    _distributeRewards(msg.sender);
    underlyingToken.transfer(msg.sender, amount);
    _burn(msg.sender, amount);
  }

  function _distributeRewards(address beneficiary) internal {
    uint checkpoint = checkpoints[beneficiary];
    if(block.number - checkpoint > 0) {
      uint distributionAmount = balanceOf(beneficiary) * (block.number - checkpoint) * REWARD_PER_BLOCK; //balance of Lp tokens
      governanceToken.mint(beneficiary, distributionAmount);
      checkpoints[beneficiary] = block.number;
    }
  }
}

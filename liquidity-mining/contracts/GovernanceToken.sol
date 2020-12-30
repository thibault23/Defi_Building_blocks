pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

//only owner of the contract can mint new governance tokens
//owner of the contract will be the liquidity pool
contract GovernanceToken is ERC20, Ownable {

  //address who deploys the contract will be the owner of the contract
  constructor() ERC20('Governance Token', 'GTK') Ownable () {

  }

  function mint(address _to, uint _amount) external onlyOwner() {
    _mint(_to, _amount);
  }
}

pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract UnderlyingToken is ERC20 {
  constructor () ERC20 ('LP Token', 'LPT') {

  }

  function faucet(address _to, uint _amount) external {
    _mint(_to, _amount);
  }
}

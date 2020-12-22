pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Weth is ERC20 {
  contructor() ERC20 ('Wrapped Ether', 'WERC20') {}

  // no amount as msg.value is our deposit
  function deposit() external payable {
    //safeTransfer(msg.sender, address(this), msg.value);
    _mint(msg.sender, msg.value);
  }

  function withdraw(_amount) external {
    require(balanceOf(msg.sender) >= _amount, 'balance not enough');
    _burn(msg.sender, _amount); // burns the wrapped Ether
    msg.sender.transfer(amount);
  }
}

pragma solidity ^0.7.0;

interface IUniswap {
  function swapExactTokensForETH(
    uint amountIn,
    uint amountOutMin,
    address[] calldata path,
    address to,
    uint deadline)
        external
        returns (uint[] memory amounts);

    function WETH() external pure returns (address); // returns the address of wrapped ethereum
}


interface IERC20 {
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  function approve(address spender, uint256 amount) external returns (bool);
}

contract MyUniswapIntegration {
  IUniswap uniswap;

  constructor (address _uniswap) {
    uniswap = IUniswap(_uniswap);
  }

  function swapTokensForEth(
    address _token,
    uint _amountIn,
    uint _amountOutMin,
    uint _deadline)
    external {
      IERC20(_token).transferFrom(msg.sender, address(this), _amountIn);
      //path is the two tokens we want to trade
      address[] memory path = new address[](2); //an array of addresses of length 2
      path[0] = _token;
      path[1] = uniswap.WETH();
      //before we call the swap exact fct, we need to approve uniswap to spend our tokens!
      IERC20(_token).approve(address(uniswap), _amountIn);
      uniswap.swapExactTokensForETH(
        _amountIn,
        _amountOutMin,
        path,
        msg.sender,
        _deadline
        );
    }
}

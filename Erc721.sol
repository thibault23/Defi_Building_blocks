pragma solidity ^0.7.3;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721Holder.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';


contract Nft is ERC721 {
  constructor () ERC721 ('nft', 'non fungible token');

  function faucet(uint256 _tokenId, address _to) external {
    _safeMint(_to, _tokenId);
  }
}

interface ContractB {
  function deposit(uint256 _tokenId) external;
  function withdraw (uint256 _tokenId) external;
}

contract ContractA is ERC721Holder {
  IERC721 public nft;
  ContractB public contractb;

  constructor (address _nft, address _contractb) {
    nft = IERC721(_nft);
    contractb = ContractB(_contractb);
  }

  function deposit(uint256 _tokenId) external {
    nft.safeTransferFrom(msg.sender, address(this), _tokenId); //will call approve
    nft.approve(address(contractb), _tokenId);
    contractb.deposit(_tokenId);
  }

  function withdraw(uint256 _tokenId) external {
    contractb.withdraw(_tokenId);
    nft.transfer(address(this), msg.sender, _tokenId); //there is no dedicated transfer fct in erc721
  }
}

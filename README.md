# Defi_Building_blocks
Implementation of various DeFi blocks

- [x] WrapperEther.sol: contract mints a 1:1 wrapped ether for ether deposits and able to withdraw as well.

- [x] CollateralBacked.sol: contract acting as a collateral backed token with pointer to collateral instantiated. Deposit and Withdraw function, deposit collateral, withdraw collateral back token.

- [x] Erc20.sol: a handful of contracts creating tokens, minting functionnalities, deposit/withdraw, forward functions.

- [x] Erc721.sol: NFT, nft minting, faucet for ERC721, nft transfer and forward.

- [x] oracles: an oracle contract that stores external BTC/USD price from coingecko, a consumer contract that can fetch the data upon request from the oracle contract, an oracle API in Javascript that gets the current BTC/USD price from coingecko and reports the data to the oracle contract.

- [x] liquidity mining: liquidity pool staking with unerlying token -> lp token and issuance of governance token.

- [x] flashloans: flashloan smart contract provider and user with callback.

- [x] dao: governance smart contract with proposal and vote functions tied to a governance token

- [x] uniswap integration: interact with uniswap smart contract using Solidity.

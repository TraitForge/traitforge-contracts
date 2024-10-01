# TraitForge Protocol

This repository contains the smart contracts source code for TraitForge Protocol.

## Contracts overview

- [`AccessController`](./contracts/core/AccessController.sol)
  Inherited from OpenZeppelin AccessControl.sol, this contract manage roles and permissions over the protocol.
- [`AddressProvider`](./contracts/core/AddressProvider.sol)
  Centralizes the main addresses of all the contracts of the protocol.
- [`TraitForgeNft`](./contracts/TraitForgeNft.sol)
  Inherited from OpenZeppelin ERC721Enumerable.sol, this contract is the NFT of the protocol
- [`Trait`](./contracts/Trait.sol)
  Inherited from OpenZeppelin ERC20Pausable.sol
- [`EntropyGenerator`](./contracts/EntropyGenerator.sol)
  This contract, generates pseudo-random six-digit numbers that can be accessed by other contracts, ensuring randomness with constraints on value ranges and providing functions to retrieve and initialize entropy values.
- [`NukeFund`](./contracts/NukeFund.sol)
  The NukeFund contract manages a fund that distributes ETH to users who "nuke" (burn) specific NFTs, with the claimable amount based on the NFT’s age and entropy, while deducting a portion as a developer fee and enforcing conditions on token maturity and claim limits.
- [`EntityForging`](./contracts/EntityForging.sol)
  The EntityForging contract facilitates the listing, forging (merging), and managing of NFTs with specific entropy-based conditions, allowing users to list NFTs for forging, combine them under certain rules, and distribute fees, while ensuring limits on forging potential and preventing re-forging of previously forged pairs.
- [`EntityTrading`](./contracts/EntityTrading.sol)
  The EntityTrading contract enables users to list, buy, and cancel the sale of NFTs on a marketplace, while charging a tax fee on sales that is transferred to a NukeFund, with full support for secure transactions and NFT ownership transfers.
- [`DevFund`](./contracts/DevFund.sol)
  The DevFund contract distributes rewards to registered developers based on their assigned weights, allowing claims of accumulated rewards, and securely managing ETH transfers to both developers and a designated collector.
- [`Airdrop`](./contracts/Airdrop.sol)
  The Airdrop contract distributes tokens to users, referrers, partners, and designated addresses, allowing claims once the airdrop starts, with allocations to liquidity pools, developers, and referral programs.
- [`DAOFund`](./contracts/DAOFund.sol)
  Soon...

## Development

- To help developers standardize commands and accelerate development, we use Make for all main commands. Developers are free to use more specific commands for tailored or advanced needs.

### Instalation

- To install the depedencies Run `make install`

### Getting Started

- Create a `.env` file according to the [`.env.example`](./.env.example) file.

### Testing with [Foundry](https://github.com/foundry-rs/foundry) 🔨

To run the whole test suite:

```bash
make test
```

or to run only tests matching an input:

```bash
make test-name NAME=matching_test_name_example
```

or to run only tests matching a contract:

```bash
make test-contract CONTRACT=contract
```

add -vvvv for verbosity
You can always refer to `forge test --help`

## Deployment

To deploy contract on a network follow the steps below:

- Check that the [`.env`](./.env) file is correctly configured with all data needed.

- Open the `.json` file link to the network you want to deploy the contract in `config` folder (ex: base it will be [`base.json`](./config/base.json) file). And fill all the data needed.

- Very important for a new deployment all the protocol addresses needs to be set to the Zero address `0x0000000000000000000000000000000000000000`

1. Deploy the AccessController: run `make deploy-accessController NETWORK=network_name` with the network name `base_sepolia | base`
2. You need to set the AccessController Address in the network file accordingly
3. Deploy the AddressProvider: run `make deploy-addressProvider NETWORK=network_name` with the network name `base_sepolia | base`
4. You need to set the AccessProvider Address in the network file accordingly
5. You can either deploy the protocol entirely now with `make deploy-all NETWORK=network_name` this will deploy all protocol but AccessController and AddressProvider, these 2 contracts needs to be deployed follwing the previous steps
6. Don't forget to fill up the config network json file with the new deployed addresses

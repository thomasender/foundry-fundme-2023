# Fund Me Smart Contract

The Smart Contract (backend) for a fund me blockchain application.

## Environment Variables

These are the environment variables you need to set in your .env file in order to have the scripts work correctly.

```
MUMBAI_RPC_URL= <youRPCUrl>
POLYGON_MAIN_RPC_URL= <yourRPCUrl>
# This is MetaMask Dev private key Account Dev Only Never use this for real money transactions!
PRIVATE_KEY=<yourDevPrivateKey>
ETHERSCAN_API_KEY=<yourEtherscanApiKey>
```

## Foundry

This project is built with Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

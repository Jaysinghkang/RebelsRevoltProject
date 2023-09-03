## RebelsRevolt
 **An ERC20 token with fixed supply of 1861933694 tokens.**

## PresaleVesting
 **A vesting smart contract for presale users. Owner will set users, amount once presale is completed** 

 Presale consist of --
   - immutable vesting duration - 6 months (180 days)
   - immutable cliff time - 1 month (30 days)
   - immutable initital unlock - 25% of the total amount
   - immutable token address - RebelsRevolt

   Once a vesting for user is added, it can not be modified by owner. This is design choice so that owner can't rug by overriding prev. values. 

   All test cases for **RebelsRevolt** and **PresaleVesting** is added in test folder. 



## Foundry

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

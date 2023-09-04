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

## Gas Reports

| src/PresaleVesting.sol:PresaleVesting contract |                 |        |        |        |         |
|------------------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                                | Deployment Size |        |        |        |         |
| 979906                                         | 5091            |        |        |        |         |
| Function Name                                  | min             | avg    | median | max    | # calls |
| addVesting                                     | 446             | 106703 | 134266 | 154166 | 19      |
| addVestingMultiple                             | 1624            | 75310  | 3391   | 272079 | 7       |
| claim                                          | 3811            | 34362  | 9524   | 73145  | 23      |
| claimOtherERC20Tokens                          | 469             | 3614   | 2693   | 6712   | 5       |
| getGlobalCliffTime                             | 192             | 192    | 192    | 192    | 1       |
| getGlobalVestingDuration                       | 237             | 237    | 237    | 237    | 1       |
| getInitialUnlock                               | 204             | 204    | 204    | 204    | 1       |
| getTokenAddress                                | 192             | 192    | 192    | 192    | 1       |
| owner                                          | 342             | 1008   | 342    | 2342   | 3       |
| renounceOwnership                              | 498             | 3560   | 4060   | 5622   | 4       |
| transferOwnership                              | 2677            | 4217   | 2731   | 7243   | 3       |
| users                                          | 1413            | 1413   | 1413   | 1413   | 20      |


| src/RebelsRevolt.sol:RebelsRevolt contract |                 |       |        |       |         |
|--------------------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost                            | Deployment Size |       |        |       |         |
| 628950                                     | 3780            |       |        |       |         |
| Function Name                              | min             | avg   | median | max   | # calls |
| allowance                                  | 804             | 804   | 804    | 804   | 3       |
| approve                                    | 599             | 23760 | 24651  | 24651 | 27      |
| balanceOf                                  | 629             | 879   | 629    | 2629  | 32      |
| decimals                                   | 222             | 222   | 222    | 222   | 1       |
| decreaseAllowance                          | 2811            | 2864  | 2811   | 2972  | 3       |
| increaseAllowance                          | 3002            | 10336 | 3054   | 24954 | 3       |
| name                                       | 3201            | 3201  | 3201   | 3201  | 1       |
| owner                                      | 346             | 1012  | 346    | 2346  | 3       |
| renounceOwnership                          | 432             | 3502  | 4002   | 5572  | 4       |
| symbol                                     | 3244            | 3244  | 3244   | 3244  | 1       |
| totalSupply                                | 2349            | 2349  | 2349   | 2349  | 1       |
| transfer                                   | 562             | 22039 | 24994  | 29794 | 99      |
| transferFrom                               | 2802            | 23063 | 25983  | 32478 | 21      |
| transferOwnership                          | 2655            | 4199  | 2720   | 7224  | 3       |

## Test Coverage
 
Ran 2 test suites: 70 tests passed, 0 failed, 0 skipped (70 total tests)

| File                   | % Lines          | % Statements     | % Branches     | % Funcs        |
|------------------------|------------------|------------------|----------------|----------------|
| src/PresaleVesting.sol | 81.11% (73/90)   | 81.74% (94/115)  | 69.05% (29/42) | 66.67% (16/24) |
| src/RebelsRevolt.sol   | 76.92% (50/65)   | 79.17% (57/72)   | 76.92% (20/26) | 88.00% (22/25) |
| Total                  | 79.35% (123/155) | 80.75% (151/187) | 72.06% (49/68) | 77.55% (38/49) |

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

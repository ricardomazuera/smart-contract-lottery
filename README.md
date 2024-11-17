## Smart Contract Lottery

This is a simple smart contract lottery system that allows users to enter a lottery by sending a certain amount of ether to the contract. The contract will then randomly select a winner from the list of participants and send the entire balance to the winner.

## Requirementes

- foundry
- [chainlink-brownie-contracts 1.1.1](https://github.com/smartcontractkit/chainlink-brownie-contracts)
- [solmate v6](https://github.com/transmissions11/solmate)
- [foundry-devops](https://github.com/Cyfrin/foundry-devops)

## Installation

1. Clone the repository
2. Install the dependencies

```shell
$ cargo install foundry
$ forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-commit
$ forge install transmissions11/solmate@v6 --no-commit
$ forge install Cyfrin/foundry-devops --no-commit
```

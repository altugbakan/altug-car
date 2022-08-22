# AltugCar

This is the code of [AltugCar](/src/cars/AltugCar.sol), which has finished in 10<sup>th</sup> place on [0xMonaco](https://0xmonaco.ctf.paradigm.xyz/) by [Paradigm CTF](https://twitter.com/paradigm_ctf).

## Tactics

AltugCar aims to save money until the last bit of the race while disrupting its enemies' economy.

## Overview

The algorithm is as follows:

1. If AltugCar is in the first place, it buys acceleration until the cost of a shell. If the second player does not have enough coins, it inflates the price of a shell.

2. If AltugCar is in the second place, it tries to catch up with the first player by buying a shell, or buying enough acceleration, whichever is cheaper.

3. If AltugCar is in the last place, it buys all the acceleration allowed to try catching up.

## Usage

1. Clone or Fork this repository

```shell
git clone https://github.com/altugbakan/altug-car
cd huff-heap-sort
```

2. Install dependencies

```shell
forge install
```

3. Build and race the car against the other cars (default: AltugCar vs ExampleCar vs ExampleCar)

```shell
forge build
forge test
```

## Acknowledgements
- [How to Play](https://0xmonaco.ctf.paradigm.xyz/howtoplay)

## Setup

1. [Install protostar](https://docs.swmansion.com/protostar/docs/tutorials/installation).
2. Build the project:

```sh
protostar build
```

3. Run the tests:

```sh
protostar test
```

## Deploy to testnet

1. Build

```sh
protostar build
```

2. Declare

```sh
starknet_declare build/tree_erc721.json
```

3. Verify source code

```sh
starkscan
```

4. Upgrade implementation by calling `upgarde` on the proxy:
   https://testnet.starkscan.co/contract/0x07b6d00f28db723199bb54ca74a879a5102c44141f0e93674b2cb25f8f253c62#write-contract

## Commands

### Compile cairo contracts

```sh
protostar build
```

### Run tests

```sh
protostar test
```

### Format source code

```sh
protostar format
```

### Install deps

```sh
protostar install OpenZeppelin/cairo-contracts@v0.4.0
```

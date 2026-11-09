> **Archived (2026-11-09): Focus Tree no longer has any crypto.** Crypto rewards, mints and the
> in-app wallets have ended; the holders' exit grace period closed on 2026-11-07. These are the
> 2022-2023 Cairo 0 contracts (`TreeERC721`), superseded by
> [focustree/contracts](https://github.com/focustree/contracts); any contract deployed from them
> is left as is. The tree metadata they point to stays served at
> `https://api.focustree.app/tree?id=<id>`. This repository is read-only.

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

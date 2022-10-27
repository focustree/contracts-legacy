export STARKNET_NETWORK="alpha-goerli"
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
export ACCOUNT="__default__"
export ACCOUNT_ADDRESS=0x6683a563773e1eb3d4005f478a5f0c532e24952125250fac63bf5ab645d1242

export UDC_ADDRESS=0x25fcb74260022bd8ed7e8d542408941826b53345e478b8303d6f31744838a36
export UDC_ABI_PATH=build/devnet/udc.abi.json
export ETH_ADDRESS=0x62230ea046a9a5fbc261ac77d03c8d41e5d442db2284587570ab46455fd2488
export ETH_ABI_PATH=build/devnet/eth.abi.json

# Output
export PROXY_HASH=0x6ad13d6c3f382bdc7d337a3928528e974b76c21153ff25a946d2c4f26ef1c6b
export TREE_HASH=0xb3e8b4bd1906e46f4b9ce2d0cbdcf747409ab506469287587b23130a600535
export TREE_ADDRESS=0x3387e5319f0b18565db1e150786e032825cf531e0a4dd450a93a10cb67eaf92

alias starknet="starknet --gateway_url http://127.0.0.1:5050 --feeder_gateway_url http://127.0.0.1:5050/feeder_gateway"

starknet_declare() {
    addr="$(starknet declare --contract $1 --account $ACCOUNT --nonce $NONCE --max_fee 993215999380800)"
    echo $addr
    comm=$(echo "$addr" | grep 'Contract class hash' | awk '{gsub("Contract class hash: ", "",$0); print $0}')
    printf -v $2 $comm
    echo "$2=$comm"
    # echo "$2=$comm" >> "$STARKNET_NETWORK_ID.test_node.txt"
    ((NONCE=$NONCE+1))
}

mint_tree() {
    echo 'Mint tree'
    to=$1
    tokenId=$2
    starknet invoke \
        --address $TREE_ADDRESS \
        --abi ./build/tree_erc721_abi.json \
        --function mint \
        --inputs $to $tokenId 0
}

balance_of() {
    echo 'Balance of'
    owner=$1
    starknet call \
        --address $TREE_ADDRESS \
        --abi ./build/tree_erc721_abi.json \
        --function balanceOf \
        --inputs $owner
}
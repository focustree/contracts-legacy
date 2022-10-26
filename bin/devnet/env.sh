export STARKNET_NETWORK="alpha-goerli"
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
export ACCOUNT="__default__"
export ACCOUNT_ADDRESS=0x6683a563773e1eb3d4005f478a5f0c532e24952125250fac63bf5ab645d1242

alias starknet="starknet --gateway_url http://127.0.0.1:5050 --feeder_gateway_url http://127.0.0.1:5050/feeder_gateway"

starknet_declare () {
    addr="$(starknet declare --contract $1 --account $ACCOUNT --nonce $NONCE --max_fee 993215999380800)"
    echo $addr
    comm=$(echo "$addr" | grep 'Contract class hash' | awk '{gsub("Contract class hash: ", "",$0); print $0}')
    printf -v $2 $comm
    echo "$2=$comm"
    # echo "$2=$comm" >> "$STARKNET_NETWORK_ID.test_node.txt"
    ((NONCE=$NONCE+1))
}
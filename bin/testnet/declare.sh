starknet_declare () {
    addr="$(starknet declare --contract $1 --account $ACCOUNT --nonce $NONCE --max_fee 993215999380800)"
    echo $addr
    comm=$(echo "$addr" | grep 'Contract class hash' | awk '{gsub("Contract class hash: ", "",$0); print $0}')
    printf -v $2 $comm
    echo "$2=$comm"
    # echo "$2=$comm" >> "$STARKNET_NETWORK_ID.test_node.txt"
    ((NONCE=$NONCE+1))
}

NONCE=$(starknet get_nonce --contract_address $ACCOUNT_ADDRESS)
starknet_declare build/proxy.json PROXY_HASH
starknet_declare build/tree_erc721.json TREE_ERC721_HASH
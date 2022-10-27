starknet_declare() {
    echo "Declare"
    nonce=$(starknet get_nonce --contract_address $ACCOUNT_ADDRESS)
    echo "Nonce: $nonce"
    starknet declare --contract $1 --account $ACCOUNT --nonce $nonce --max_fee 993215999380800
}

mint_tree() {
    echo 'Mint tree'
    to=$1
    starknet invoke \
        --address $TREE_ADDRESS \
        --abi ./build/tree_erc721_abi.json \
        --function mint \
        --inputs $to 
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
upgrade() {
    echo 'Upgrade'
    new_implementation_hash=$1
    starknet invoke \
        --address $TREE_ADDRESS \
        --abi ./build/tree_erc721_abi.json \
        --function upgrade \
        --inputs $new_implementation_hash
}

get_tx() {
    starknet get_transaction_receipt --hash $1
}

set_minter() {
    echo 'Set Minter'
    minterAddress=$1
    starknet invoke \
        --address $TREE_ADDRESS \
        --abi ./build/tree_erc721_abi.json \
        --function setMinter \
        --inputs $minterAddress
}
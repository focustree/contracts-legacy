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
export TREE_HASH=0x64408049251a609c5e33332cf2abf2affce4e3dd5bdab815a83ab7c249a63c7
# export TREE_HASH_V1=0xb3e8b4bd1906e46f4b9ce2d0cbdcf747409ab506469287587b23130a600535
export TREE_ADDRESS=0x3387e5319f0b18565db1e150786e032825cf531e0a4dd450a93a10cb67eaf92

alias starknet="starknet --gateway_url http://127.0.0.1:5050 --feeder_gateway_url http://127.0.0.1:5050/feeder_gateway"

starknet_declare() {
    echo "Declare $1"
    nonce=$(starknet get_nonce --contract_address $ACCOUNT_ADDRESS)
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
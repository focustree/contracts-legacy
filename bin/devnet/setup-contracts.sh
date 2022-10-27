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
export TREE_ADDRESS=0x025fcb74260022bd8ed7e8d542408941826b53345e478b8303d6f31744838a36

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


echo 'Mint some eth to the account address'
curl -X POST -H "Content-Type: application/json" -d '{ "address": "'$ACCOUNT_ADDRESS'", "amount": 100000000000000000000000000 }' http://127.0.0.1:5050/mint

echo 'Deploy account'
starknet deploy_account

echo 'Dump ETH abi'
rm $ETH_ABI_PATH
starknet get_code --contract_address $ETH_ADDRESS | jq .abi > $ETH_ABI_PATH

echo 'Dump UDC abi'
rm $UDC_ABI_PATH
starknet get_full_contract --contract_address $UDC_ADDRESS | jq .abi > $UDC_ABI_PATH                           

echo 'Get ETH balance'
starknet call --abi $ETH_ABI_PATH \
    --address $ETH_ADDRESS \
    --function balanceOf \
    --inputs $ACCOUNT_ADDRESS

NONCE=$(starknet get_nonce --contract_address $ACCOUNT_ADDRESS)
starknet_declare build/proxy.json PROXY_HASH
starknet_declare build/tree_erc721.json TREE_ERC721_HASH

echo 'Deploy tree'
class_hash=$PROXY_HASH
salt=0
unique=0
implementation_hash=$TREE_HASH
selector=0x2dd76e7ad84dbed81c314ffe5e7a7cacfb8f4836f01af4e913f275f89a3de1a # initializer
proxy_admin=$ACCOUNT_ADDRESS
owner=$ACCOUNT_ADDRESS
starknet invoke \
    --address $UDC_ADDRESS \
    --abi ./build/devnet/udc.abi.json \
    --function deployContract \
    --inputs $class_hash $salt $unique 5 $implementation_hash $selector_hash 2 $proxy_admin $owner
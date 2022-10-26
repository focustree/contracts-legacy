source bin/devnet/env.sh

echo 'Mint some eth to the account address'
curl -X POST -H "Content-Type: application/json" -d '{ "address": "'$ACCOUNT_ADDRESS'", "amount": 100000000000000000000000000 }' http://127.0.0.1:5050/mint

echo 'Deploy account'
starknet deploy_account

echo 'Dump ETH abi'
ETH_ADDRESS=0x62230ea046a9a5fbc261ac77d03c8d41e5d442db2284587570ab46455fd2488
ETH_ABI_PATH=build/devnet/eth.abi.json
starknet get_code --contract_address $ETH_ADDRESS | jq .abi > $ETH_ABI_PATH

echo 'Get ETH balance'
starknet call --abi $ETH_ABI_PATH \
    --address $ETH_ADDRESS \
    --function balanceOf \
    --inputs $ACCOUNT_ADDRESS

NONCE=$(starknet get_nonce --contract_address $ACCOUNT_ADDRESS)
starknet_declare build/proxy.json PROXY_HASH
starknet_declare build/tree_erc721.json TREE_ERC721_HASH

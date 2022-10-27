source bin/devnet/set-account-to-not-deployed.sh

echo 'Mint some eth to the account address'
curl -X POST -H "Content-Type: application/json" -d '{ "address": "'$ACCOUNT_ADDRESS'", "amount": 100000000000000000000000000 }' http://127.0.0.1:5050/mint

echo 'Get ETH balance'
starknet call --abi $ETH_ABI_PATH \
    --address $ETH_ADDRESS \
    --function balanceOf \
    --inputs $ACCOUNT_ADDRESS

echo 'Deploy account'
starknet deploy_account

# echo 'Dump ETH abi'
# rm $ETH_ABI_PATH
# starknet get_code --contract_address $ETH_ADDRESS | jq .abi > $ETH_ABI_PATH

# echo 'Dump UDC abi'
# rm $UDC_ABI_PATH
# starknet get_full_contract --contract_address $UDC_ADDRESS | jq .abi > $UDC_ABI_PATH                           

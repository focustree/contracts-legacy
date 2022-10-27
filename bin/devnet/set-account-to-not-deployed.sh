json_path=~/.starknet_accounts/starknet_open_zeppelin_accounts.json
mv $json_path temp.json
jq -r '."alpha-goerli"."__default__".deployed |= false' temp.json > $json_path
rm temp.json
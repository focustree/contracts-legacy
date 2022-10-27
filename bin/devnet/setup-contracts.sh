NONCE=$(starknet get_nonce --contract_address $ACCOUNT_ADDRESS)
starknet_declare build/proxy.json PROXY_HASH
starknet_declare build/tree_erc721.json TREE_ERC721_HASH

echo 'Deploy tree'
class_hash=$PROXY_HASH
salt=0
unique=0
implementation_hash=$TREE_ERC721_HASH
selector=0x2dd76e7ad84dbed81c314ffe5e7a7cacfb8f4836f01af4e913f275f89a3de1a # initializer
proxy_admin=$ACCOUNT_ADDRESS
owner=$ACCOUNT_ADDRESS
starknet invoke \
    --address $UDC_ADDRESS \
    --abi ./build/devnet/udc.abi.json \
    --function deployContract \
    --inputs $class_hash $salt $unique 5 $implementation_hash $selector 2 $proxy_admin $owner
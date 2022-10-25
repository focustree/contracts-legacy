%lang starknet

@external
func up() {
    %{
        import json
        from starkware.starknet.public.abi import get_selector_from_name

        account_address = 0x046a1aa85bb0E68Cd29fADBc81791208ddEbEe17886F075935e5b72f4AA898aA

        proxy_admin = account_address
        owner = account_address

        tree_implementation_hash = declare("tree_erc721", config={"wait_for_acceptance": True, "max_fee": "auto",}).class_hash
        tree_proxy_address = deploy_contract("proxy", {
            "implementation_hash": tree_implementation_hash,
            "selector": get_selector_from_name("initializer"),
            "calldata": [
                proxy_admin,
                owner,
            ]
        }, config={"wait_for_acceptance": True}).contract_address

        print(json.dumps({
            "proxy_admin": hex(proxy_admin),
            "owner": hex(owner),
            "tree_001_implementation_hash": hex(tree_implementation_hash),
            "tree_proxy_address": hex(tree_proxy_address),
        }, indent=4))
    %}
    return ();
}

@external
func down() {
    %{ assert False, "Not implemented" %}
    return ();
}

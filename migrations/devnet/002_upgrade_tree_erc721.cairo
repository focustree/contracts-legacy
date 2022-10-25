%lang starknet

@external
func up() {
    %{
        import json
        from starkware.starknet.public.abi import get_selector_from_name

        tree_proxy_address = 0xaa048997e2ed0f79f2bc0c5ffd3f3d40d47fb0de5173ca1aff4d82418c45a1

        # new_tree_erc721_hash = declare("tree_erc721_002", config={"wait_for_acceptance": True, "max_fee": "auto",}).class_hash
        #invoke(
        #    tree_proxy_address,
        #    "upgrade",
        #    {"new_implementation": new_tree_erc721_hash},
        #    config={
        #        "max_fee": "auto",
        #        "wait_for_acceptance": True,
        #    }
        #)
        toto = call(
            tree_proxy_address,
            "name",
            None, 
        )
        print(toto)

        print(json.dumps({
            "tree_proxy_address": hex(tree_proxy_address),
            "new_tree_erc721_hash": hex(new_tree_erc721_hash),
        }, indent=4))
    %}
    return ();
}

@external
func down() {
    %{ assert False, "Not implemented" %}
    return ();
}
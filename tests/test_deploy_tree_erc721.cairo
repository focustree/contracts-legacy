%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE, FALSE

from focustree.TreeERC721.ITreeERC721 import ITreeERC721

// Protostar executes __setup__ only once per test suite. 
// Then, for each test case Protostar copies the StarkNet state and the context object.
@view
func __setup__{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    %{
        from starkware.starknet.public.abi import get_selector_from_name
        context.account = 123456
    %}

    // Deploy the TreeERC721 contract
    %{
        tree_erc721_hash = declare("src/focustree/TreeERC721/TreeERC721.cairo").class_hash
        context.tree_erc721_contract_address = deploy_contract("src/focustree/Proxy.cairo", {
            "implementation_hash": tree_erc721_hash,
            "selector": get_selector_from_name("initializer"),
            "calldata": [
                context.account, # proxy_admin
                context.account, # owner
            ]
        }).contract_address
    %}

    return ();
}

@view
func test_tree_erc721_total_supply{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    tempvar tree_erc721_contract_address;
    %{ ids.tree_erc721_contract_address = context.tree_erc721_contract_address %}

    let (total_supply) = ITreeERC721.totalSupply(tree_erc721_contract_address);
    assert total_supply = Uint256(0,0);

    return ();
}

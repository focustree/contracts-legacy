%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, assert_uint256_eq
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.alloc import alloc

from focustree.TreeERC721.ITreeERC721 import ITreeERC721

// Protostar executes __setup__ only once per test suite.
// Then, for each test case Protostar copies the StarkNet state and the context object.
@view
func __setup__{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    // Deploy the TreeERC721 contract
    %{
        from starkware.starknet.public.abi import get_selector_from_name

        context.account = 28
        tree_erc721_hash = declare("src/focustree/TreeERC721/TreeERC721.cairo").class_hash
        context.tree_contract_address = deploy_contract("src/focustree/Proxy.cairo", {
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
func test_tree_erc721_init{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}(
    ) {
    alloc_locals;
    local tree_contract_address;
    %{ ids.tree_contract_address = context.tree_contract_address %}

    let (total_supply) = ITreeERC721.totalSupply(tree_contract_address);
    assert total_supply = Uint256(0, 0);

    let (minter) = ITreeERC721.minter(tree_contract_address);
    assert 0x00df9a473b56345f0781b0bee5a9f32cd2d8f4116915a0252c2f51917e357156 = minter;

    let (base_token_uri_len, base_token_uri) = ITreeERC721.baseTokenURI(tree_contract_address);
    %{
        ascii_list = list(map(lambda i: memory[ids.base_token_uri + i], range(ids.base_token_uri_len)))
        base_token_uri = "".join(map(chr, ascii_list))
        assert base_token_uri == "https://api.focustree.app/tree?id="
    %}

    return ();
}

@view
func test_tree_erc721_mint_revert_if_no_minter{
    syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    local tree_contract_address;
    %{
        ids.tree_contract_address = context.tree_contract_address
        stop_prank = start_prank(28, context.tree_contract_address)
    %}

    // Cannot mint if minter is 0
    %{ expect_revert(error_message="ERC721: caller is not the minter") %}
    ITreeERC721.mint(tree_contract_address, 28);

    return ();
}

@view
func test_tree_erc721_mint_many_revert_if_not_owner{
    syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*
}() {
    alloc_locals;
    local tree_contract_address;
    %{
        ids.tree_contract_address = context.tree_contract_address
        stop_prank = start_prank(123, context.tree_contract_address)
    %}

    // Cannot mint if not the owner
    %{ expect_revert(error_message="Ownable: caller is not the owner") %}
    ITreeERC721.mintMany(tree_contract_address, 28, 10);

    return ();
}

@view
func test_tree_erc721_mint{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    alloc_locals;
    local tree_contract_address;
    %{
        ids.tree_contract_address = context.tree_contract_address
        stop_prank = start_prank(28, context.tree_contract_address)
    %}

    // mint
    ITreeERC721.setMinter(tree_contract_address, 28);
    ITreeERC721.mint(tree_contract_address, 28);
    let (balance) = ITreeERC721.balanceOf(tree_contract_address, 28);
    assert_uint256_eq(Uint256(1, 0), balance);
    let (owner) = ITreeERC721.ownerOf(tree_contract_address, Uint256(1, 0));
    assert 28 = owner;

    // mintMany
    ITreeERC721.mintMany(tree_contract_address, 28, 10);
    let (new_balance) = ITreeERC721.balanceOf(tree_contract_address, 28);
    assert_uint256_eq(Uint256(11, 0), new_balance);

    %{ stop_prank() %}

    return ();
}

@view
func test_tree_erc721_token_uri{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {
    alloc_locals;
    local tree_contract_address;
    %{
        ids.tree_contract_address = context.tree_contract_address
        stop_prank = start_prank(28, context.tree_contract_address)
    %}

    // Set base token URI to https://api.focustree.app/tree?id=
    // Get felt array using https://cairo-utils-web.vercel.app/
    ITreeERC721.setBaseTokenURI(
        tree_contract_address,
        34,
        new (104, 116, 116, 112, 115, 58, 47, 47, 97, 112, 105, 46, 102, 111, 99, 117, 115, 116, 114, 101, 101, 46, 97, 112, 112, 47, 116, 114, 101, 101, 63, 105, 100, 61),
    );
    let (base_token_uri_len, base_token_uri) = ITreeERC721.baseTokenURI(tree_contract_address);
    %{
        ascii_list = list(map(lambda i: memory[ids.base_token_uri + i], range(ids.base_token_uri_len)))
        base_token_uri = "".join(map(chr, ascii_list))
        assert base_token_uri == "https://api.focustree.app/tree?id="
    %}
    assert 34 = base_token_uri_len;
    assert 104 = base_token_uri[0];
    assert 61 = base_token_uri[33];

    // Mint
    ITreeERC721.setMinter(tree_contract_address, 28);
    ITreeERC721.mint(tree_contract_address, 28);
    ITreeERC721.mint(tree_contract_address, 28);
    ITreeERC721.mint(tree_contract_address, 28);
    ITreeERC721.mint(tree_contract_address, 28);
    ITreeERC721.mint(tree_contract_address, 28);
    ITreeERC721.mint(tree_contract_address, 28);
    ITreeERC721.mint(tree_contract_address, 28);
    ITreeERC721.mint(tree_contract_address, 28);
    ITreeERC721.mint(tree_contract_address, 28);

    // Check token URI is fine
    let (token_uri_len, token_uri) = ITreeERC721.tokenURI(tree_contract_address, Uint256(1, 0));
    assert 35 = token_uri_len;
    %{
        ascii_list = list(map(lambda i: memory[ids.token_uri + i], range(ids.token_uri_len)))
        token_uri = "".join(map(chr, ascii_list))
        assert token_uri == "https://api.focustree.app/tree?id=1"
    %}

    %{ stop_prank() %}

    return ();
}

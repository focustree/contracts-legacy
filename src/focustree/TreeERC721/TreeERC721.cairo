// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.4.0b (token/erc721/enumerable/presets/ERC721EnumerableMintableBurnable.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_unsigned_div_rem
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.alloc import alloc

from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.token.erc721.library import ERC721
from openzeppelin.token.erc721.enumerable.library import ERC721Enumerable
from openzeppelin.upgrades.library import Proxy

//
// Proxy
//

// Externals

@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    proxy_admin: felt, owner: felt
) {
    Proxy.initializer(proxy_admin);
    ERC721.initializer('TreeERC21', 'TREE');
    ERC721Enumerable.initializer();
    Ownable.initializer(owner);

    // ///////////////
    // Init config //
    // ///////////////
    _setBaseTokenURI(
        34,
        new (104, 116, 116, 112, 115, 58, 47, 47, 97, 112, 105, 46, 102, 111, 99, 117, 115, 116, 114, 101, 101, 46, 97, 112, 112, 47, 116, 114, 101, 101, 63, 105, 100, 61),
    );  // Set base token URI to: https://api.focustree.app/tree?id=
    _setMinter(0x00df9a473b56345f0781b0bee5a9f32cd2d8f4116915a0252c2f51917e357156);  // Set Mintsquare minter

    return ();
}

@external
func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_implementation: felt
) {
    Proxy.assert_only_admin();
    Proxy._set_implementation_hash(new_implementation);
    return ();
}

//
// ERC721
//

// Views

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    return ERC721.name();
}

@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
    return ERC721.symbol();
}

@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt) -> (
    balance: Uint256
) {
    return ERC721.balance_of(owner);
}

@view
func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    owner: felt
) {
    return ERC721.owner_of(tokenId);
}

@view
func getApproved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (approved: felt) {
    return ERC721.get_approved(tokenId);
}

@view
func isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, operator: felt
) -> (isApproved: felt) {
    let (isApproved: felt) = ERC721.is_approved_for_all(owner, operator);
    return (isApproved=isApproved);
}

@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    return Ownable.owner();
}

// Externals

@external
func approve{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt, tokenId: Uint256
) {
    ERC721.approve(to, tokenId);
    return ();
}

@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    operator: felt, approved: felt
) {
    ERC721.set_approval_for_all(operator, approved);
    return ();
}

@external
func transferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256
) {
    ERC721Enumerable.transfer_from(from_, to, tokenId);
    return ();
}

@external
func safeTransferFrom{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256, data_len: felt, data: felt*
) {
    ERC721Enumerable.safe_transfer_from(from_, to, tokenId, data_len, data);
    return ();
}

@external
func setTokenURI{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    tokenId: Uint256, tokenURI: felt
) {
    Ownable.assert_only_owner();
    ERC721._set_token_uri(tokenId, tokenURI);
    return ();
}

@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    Ownable.transfer_ownership(newOwner);
    return ();
}

@external
func renounceOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Ownable.renounce_ownership();
    return ();
}

//
// ERC165
//

// Views

@view
func supportsInterface{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    interfaceId: felt
) -> (success: felt) {
    return ERC165.supports_interface(interfaceId);
}

//
// Enumerable
//

// Views

@view
func totalSupply{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() -> (
    totalSupply: Uint256
) {
    let (totalSupply: Uint256) = ERC721Enumerable.total_supply();
    return (totalSupply=totalSupply);
}

@view
func tokenByIndex{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    index: Uint256
) -> (tokenId: Uint256) {
    let (tokenId: Uint256) = ERC721Enumerable.token_by_index(index);
    return (tokenId=tokenId);
}

@view
func tokenOfOwnerByIndex{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    owner: felt, index: Uint256
) -> (tokenId: Uint256) {
    let (tokenId: Uint256) = ERC721Enumerable.token_of_owner_by_index(owner, index);
    return (tokenId=tokenId);
}

// Externals

@external
func burn{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(tokenId: Uint256) {
    ERC721.assert_only_token_owner(tokenId);
    ERC721Enumerable._burn(tokenId);
    return ();
}

//
// Focus Tree
//

// Storage

@storage_var
func TreeERC721_minter() -> (minter: felt) {
}

@storage_var
func TreeERC721_baseTokenURI(index: felt) -> (char: felt) {
}

// Views

@view
func minter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (minter: felt) {
    let (minter) = TreeERC721_minter.read();
    return (minter,);
}

@view
func baseTokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    baseTokenURI_len: felt, baseTokenURI: felt*
) {
    let (first_char) = TreeERC721_baseTokenURI.read(0);
    let (array) = alloc();
    let (baseTokenURI_len, baseTokenURI) = _read_base_token_uri(0, array);
    return (baseTokenURI_len, baseTokenURI);
}

@view
func tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (tokenURI_len: felt, tokenURI: felt*) {
    alloc_locals;
    let (local base_token_uri_len, local base_token_uri) = baseTokenURI();
    let (added_len) = _append_number_ascii(tokenId, base_token_uri + base_token_uri_len);
    return (base_token_uri_len + added_len, base_token_uri);
}

// Externals

@external
func mint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(to: felt) {
    let (minter) = TreeERC721_minter.read();
    let (caller) = get_caller_address();
    with_attr error_message("ERC721: caller is the zero address") {
        assert_not_zero(caller);
    }
    with_attr error_message("ERC721: caller is not the minter") {
        assert minter = caller;
    }
    _mint(to);
    return ();
}

@external
func mintMany{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt, count: felt
) {
    Ownable.assert_only_owner();
    _mintMany(to, count);
    return ();
}

func _mintMany{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt, count: felt
) {
    if (count == 0) {
        return ();
    }
    _mint(to);
    _mintMany(to, count - 1);
    return ();
}

func _mint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(to: felt) {
    let (tokenId: Uint256) = totalSupply();
    let (newTokenId: Uint256, _) = uint256_add(tokenId, Uint256(1, 0));
    ERC721Enumerable._mint(to, newTokenId);
    return ();
}

@external
func setMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(newMinter: felt) {
    Ownable.assert_only_owner();
    _setMinter(newMinter);
    return ();
}

func _setMinter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(newMinter: felt) {
    TreeERC721_minter.write(newMinter);
    return ();
}

@external
func setBaseTokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    baseTokenURI_len: felt, baseTokenURI: felt*
) {
    Ownable.assert_only_owner();
    _setBaseTokenURI(baseTokenURI_len, baseTokenURI);
    return ();
}

func _setBaseTokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    baseTokenURI_len: felt, baseTokenURI: felt*
) {
    _write_base_token_uri(baseTokenURI_len, baseTokenURI);
    return ();
}

// Private

// Recursively store the array from the last character to the first one.
// We store value + 1 to differrentiate 0 values from unassigned ones.
func _write_base_token_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    uri_len: felt, uri: felt*
) {
    if (uri_len == 0) {
        return ();
    }
    tempvar new_len = uri_len - 1;
    TreeERC721_baseTokenURI.write(new_len, uri[new_len] + 1);
    _write_base_token_uri(new_len, uri);
    return ();
}

// Recursively read the array from the first char to the last.
// We stop when we encounter the 0 value.
func _read_base_token_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    array_len: felt, array: felt*
) -> (array_len: felt, array: felt*) {
    let (val) = TreeERC721_baseTokenURI.read(array_len);
    if (val == 0) {
        return (array_len, array);
    }
    assert array[array_len] = val - 1;
    return _read_base_token_uri(array_len + 1, array);
}

func _append_number_ascii{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    num: Uint256, array_end: felt*
) -> (added_len: felt) {
    alloc_locals;
    local ten: Uint256 = Uint256(10, 0);
    let (q: Uint256, r: Uint256) = uint256_unsigned_div_rem(num, ten);
    let digit = r.low + 48;  // ascii

    if (q.low == 0 and q.high == 0) {
        assert array_end[0] = digit;
        return (1,);
    }

    let (added_len) = _append_number_ascii(q, array_end);
    assert array_end[added_len] = digit;
    return (added_len + 1,);
}

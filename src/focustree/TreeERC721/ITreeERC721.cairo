%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ITreeERC721 {
    // Proxy
    func initializer(proxy_admin: felt, owner: felt) {
    }
    func upgrade(new_implementation: felt) {
    }
    // ERC721 metadata
    func name() -> (name: felt) {
    }
    func symbol() -> (symbol: felt) {
    }
    // ERC721
    func balanceOf(owner: felt) -> (balance: Uint256) {
    }
    func ownerOf(tokenId: Uint256) -> (owner: felt) {
    }
    func safeTransferFrom(from_: felt, to: felt, tokenId: Uint256, data_len: felt, data: felt*) {
    }
    func transferFrom(from_: felt, to: felt, tokenId: Uint256) {
    }
    func approve(approved: felt, tokenId: Uint256) {
    }
    func setApprovalForAll(operator: felt, approved: felt) {
    }
    func getApproved(tokenId: Uint256) -> (approved: felt) {
    }
    func isApprovedForAll(owner: felt, operator: felt) -> (isApproved: felt) {
    }
    // ERC165
    func supportsInterface(interfaceId: felt) -> (success: felt) {
    }
    // Enumerable
    func totalSupply() -> (totalSupply: Uint256) {
    }
    func tokenByIndex(index: Uint256) -> (tokenId: Uint256) {
    }
    func tokenOfOwnerByIndex(owner: felt, index: Uint256) -> (tokenId: Uint256) {
    }
    func burn(tokenId: Uint256) {
    }
    // Focus Tree
    func minter() -> (minter: felt) {
    }
    func baseTokenURI() -> (baseTokenURI_len: felt, baseTokenURI: felt*) {
    }
    func tokenURI(tokenId: Uint256) -> (tokenURI_len: felt, tokenURI: felt*) {
    }
    func mint(to: felt) -> () {
    }
    func mintMany(to: felt, count: felt) -> () {
    }
    func setMinter(minter: felt) -> () {
    }
    func setBaseTokenURI(baseTokenURI_len: felt, baseTokenURI: felt*) -> () {
    }
}

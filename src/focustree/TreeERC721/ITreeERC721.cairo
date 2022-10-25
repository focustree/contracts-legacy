%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ITreeERC721 {
    func totalSupply() -> (count: Uint256) {
    }
    func mint(to: felt, tokenId: Uint256) {
    }
    func transferFrom(from_: felt, to: felt, tokenId: Uint256) {
    }
    func setContractURIHash(hash_len: felt, hash: felt*) {
    }
    func contractURI() -> (contractURI_len: felt, contractURI: felt*) {
    }
    func tokenURI(tokenId: Uint256) -> (tokenURI_len: felt, tokenURI: felt*) {
    }
    func owner() -> (owner: felt) {
    }
    func transferOwnership(newOwner: felt) -> () {
    }
    func balanceOf(owner: felt) -> (balance: Uint256) {
    }
    func ownerOf(tokenId: Uint256) -> (owner: felt) {
    }
}

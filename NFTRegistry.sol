// SPDX-License-Identifier: MIT

pragma solidity ^0.5.5;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";


contract NFTRegistry is ERC721Full {
    address contractAddress;
    
    constructor(address auctionAddress) public ERC721Full("AuctionToken", "AUT") {
        contractAddress = auctionAddress;
    }

    struct NFT {
        string name;
        string owner;
        uint256 price;
    }

    mapping(uint256 => NFT) public NFTCollection;

    event Price(uint256 tokenId, uint256 price, string reportURI);

    function registerNFT(
        address owner,
        string memory name,
        string memory creator,
        uint256 initialPriceValue,
        string memory tokenURI
    ) public returns (uint256) {
        uint256 tokenId = totalSupply();

        _mint(owner, tokenId);
        _setTokenURI(tokenId, tokenURI);

        NFTCollection[tokenId] = NFT(name, creator, initialPriceValue);

        return tokenId;
    }

    function newPrice(
        uint256 tokenId,
        uint256 newPriceValue,
        string memory reportURI
    ) public returns (uint256) {
        NFTCollection[tokenId].price = newPriceValue;

        emit Price(tokenId, newPriceValue, reportURI);

        return NFTCollection[tokenId].price;
    }
}
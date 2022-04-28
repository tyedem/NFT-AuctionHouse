// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract NFTRegistry is ERC721 {
    address contractAddress;
    
    constructor(address auctionAddress) public ERC721("AuctionToken", "AUT") {
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
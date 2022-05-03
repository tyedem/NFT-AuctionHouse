// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract AuctionRegistry is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    address contractAddress;

    address payable auctionOwner;
    uint256 registrationPrice = 0.01 ether;
    uint256 auctionCount=0;

    constructor(address auctionAddress) ERC721("AuctionRegistry", "AUT") {
        contractAddress = auctionAddress;
    }

    struct NFT {
        address owner;
        string name;
        string creator;
        string uri;
        uint256 tokenId;
    }

    mapping(uint256 => NFT) public AuctionCollection;

    function registerNFT(
        address owner,
        string memory name,
        string memory creator,
        string memory uri
    ) public payable onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();

        _tokenIdCounter.increment();
        _safeMint(owner, tokenId);
        _setTokenURI(tokenId, uri);

        require(msg.value == registrationPrice, "Price must be equal to listing price of 0.01 ETH");
        payable(msg.sender);
        AuctionCollection[auctionCount] = NFT(owner, name, creator, uri, tokenId);
        auctionCount++;
		
    }
    // The following function returns the AuctionCollection
    //function getCollection() public view returns (string memory){
    //    return AuctionCollection[0].name;
    //}
    function getCollection() public view returns (uint[] memory, string[] memory,string[] memory){
      //uint auctionCount = 1; //need to acually set it to length (# of items) in AuctionCollection
      uint[]    memory id = new uint[](auctionCount);
      string[]  memory name = new string[](auctionCount);
      string[]    memory uri = new string[](auctionCount);
      for (uint i = 0; i < auctionCount; i++) {
          NFT storage art = AuctionCollection[i];
          id[i] = art.tokenId;
          name[i] = art.name;
          uri[i] = art.uri;
      }

      return (id, name, uri);

  }



    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
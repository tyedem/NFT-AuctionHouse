// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract MaticUsdMumbaiOracle {

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Polygon Testnet (Mumbai)
     * Aggregator: MATIC/USD
     * Address: 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada
     */
    constructor() {
        priceFeed = AggregatorV3Interface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (
        uint80 roundID, 
        int price,
        uint startedAt,
        uint timeStamp,
        uint80 answeredInRound
    ) {
        (
            roundID, 
            price,
            startedAt,
            timeStamp,
            answeredInRound
        ) = priceFeed.latestRoundData();
    }   
}

contract AuctionRegistry is ERC721, ERC721URIStorage, Ownable, MaticUsdMumbaiOracle {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    address contractAddress;

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
    ) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();

        _tokenIdCounter.increment();
        _safeMint(owner, tokenId);
        _setTokenURI(tokenId, uri);

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
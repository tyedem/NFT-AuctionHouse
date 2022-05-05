// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
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

contract AuctionRegistry is ERC721, ERC721URIStorage, AccessControl, MaticUsdMumbaiOracle {
    using Counters for Counters.Counter;
    address contractAddress;

    bytes32 public constant registrant = keccak256("Registrant");

    Counters.Counter private _tokenIdCounter;

    constructor(address auctionAddress) ERC721("AuctionRegistry", "AUT") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(registrant, msg.sender);
        contractAddress = auctionAddress;
    }

    function registerNFT(
        address owner,
        string memory name,
        string memory creator,
        string memory uri
    ) public onlyRole(registrant) {
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

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
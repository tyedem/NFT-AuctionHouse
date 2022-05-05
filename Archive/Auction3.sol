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

    address payable auctionOwner;
    uint256 registrationPrice = 0.01 ether;

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
contract Auction {
    event Start();
    event End(address highestBidder, uint highestBid);
    event Bid(address indexed sender, uint amount); // index allows you to check the events
    event Withdraw(address indexed bidder, uint amount);

    address payable public seller;  // seller information

    bool public started;
    bool public ended;
    uint public endAt;   // time to end the auction

// define the NFT that will be auctioned - store contract of NFT + unique ID of the NFT you need to auction
    IERC721 public nft;
    uint public nftId;

    uint public highestBid;     // highest bidder - keeping it public for trust
    address public highestBidder;
    mapping(address => uint) public bids;    //map all bids withdraw if you dont win the bid

    constructor () {
        seller = payable(msg.sender);
    }

// seller can start the auction
    function start(IERC721 _nft, uint _nftId, uint startingBid) external {
        require(!started, "Already started!");
        require(msg.sender == seller, "You did not start the auction!");
        highestBid = startingBid;

        nft = _nft; // contract representing NFT
        nftId = _nftId;
        nft.transferFrom(msg.sender, address(this), nftId); //transfer from owner to contract

        started = true;
        endAt = block.timestamp + 2 days;

        emit Start();
    }

    function bid() external payable {
        require(started, "Not started.");
        require(block.timestamp < endAt, "Ended!");
        require(msg.value > highestBid);

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(highestBidder, highestBid);
    }

    function withdraw() external payable {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        (bool sent, bytes memory data) = payable(msg.sender).call{value: bal}("");
        require(sent, "Could not withdraw");

        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require(started, "You need to start first!");
        require(block.timestamp >= endAt, "Auction is still ongoing!");
        require(!ended, "Auction already ended!");

        if (highestBidder != address(0)) {
            nft.transfer(highestBidder, nftId);  // transfer to highest bidder
            (bool sent, bytes memory data) = seller.call{value: highestBid}("");
            require(sent, "Could not pay seller!");
        } else {
            nft.transfer(seller, nftId);   // return to self if highest bid is 0
        }

        ended = true;
        emit End(highestBidder, highestBid);
    }
 //   function getNFTs() external
 //   {
        //trying first with specific position = 0
        //return nft.getCollection();
       // return "HERE";
 //   }
  
}

}
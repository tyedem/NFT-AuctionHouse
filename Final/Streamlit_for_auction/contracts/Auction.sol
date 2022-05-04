// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

// Link to the NFT - transfer ownership
interface IERC721 {
    function transfer(address, uint) external;

    function transferFrom(
        address,
        address,
        uint
    ) external;
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
}
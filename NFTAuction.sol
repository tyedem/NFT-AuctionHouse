// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

// Link to the NFT that we want to list - transfer ownership
interface IERC721 {
    function transfer(address, uint) external;

    function transferFrom(
        address,
        address,
        uint
    ) external;
}

contract NFTAuction {
    event Start();
    event End(address highestBidder, uint highestBid);
    event Bid(address indexed sender, uint amount); // index allows you to check the events
    event Cancel();
    event Withdraw(address indexed bidder, uint amount);

// parameters of the auction
    address payable public seller;  // seller information

    bool public started;  // when the auction has started
    bool public ended;  // when the auction has ended
    uint public endAt;   // when the auction is going to end
    bool public canceled;

// define the NFT that will be auctioned - store contract of NFT + unique ID of our NFT
    IERC721 public nft;
    uint public nftId;

// current state of the endAt
    uint public highestBid;  // highest bid - keeping it public for trust
    address public highestBidder;  // highest bidder - keeping it public for trust - doesn't need to be payable
    // uint public bidIncreasePercentage;
    // uint public feePercentages;
    mapping(address => uint) public bids;  // map all bids to keep track of all the bids that users have made to this contract 
    // Also bidders who don't win the auction should have the ability to withdraw their money from the contract  

    constructor () {        
        seller = payable(msg.sender); //assign the seller
        // bidIncreasePercentage = 100;
        // feePercentages = 10;
    }

// only seller can start the auction
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
// create the bid function
     function bid() external payable {
        require(started, "Not started.");
        require(block.timestamp < endAt, "Ended!");
        require(msg.value > highestBid);

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

// the highest bid needs to be updated
        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(highestBidder, highestBid);
    }

// create the cancel function
    function cancel() external returns (bool success) {
        require(msg.sender == seller, "You are not the seller in this auction!");
        require(block.timestamp < endAt, "Auction already ended!");
        require(!canceled, "Auction already canceled!");
    
        canceled = true;
        emit Cancel();
        return true;
}

// create the withdraw function
    function withdraw() external payable {
        
        address withdrawalAccount;
        uint withdrawalAmount;
        uint bal = bids[msg.sender];
        bool sent; 
        bytes memory data;
        if (canceled) {
            // if the auction was canceled, everyone should simply be allowed to withdraw their funds
             withdrawalAccount == msg.sender;
             withdrawalAmount = bids[withdrawalAccount];
            (sent, data) = payable(withdrawalAccount).call{value: withdrawalAmount}("");
            require(sent, "Could not withdraw");

        } else {
            // the auction finished without being canceled
             bids[msg.sender] = 0;
            (sent, data) = payable(msg.sender).call{value: bal}("");
            require(sent, "Could not withdraw");

        }
        emit Withdraw(msg.sender, bal);
    }


// create the end function
    function end() external {
        require(started, "You need to start first!");
        require(block.timestamp >= endAt, "Auction is still ongoing!");
        require(!ended, "Auction already ended!");
        bool sent;
        bytes memory data;
        if (highestBidder != address(0)) {
            nft.transfer(highestBidder, nftId);  // transfer NFT to highest bidder (the winner)
            (sent, data) = seller.call{value: highestBid}("");
            require(sent, "Could not pay seller!");
        } else {
            nft.transfer(seller, nftId);   // return to self if there are no bids
        }

        ended = true;
        emit End(highestBidder, highestBid);
    }
}
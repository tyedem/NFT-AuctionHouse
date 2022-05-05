# Project 3: Auction Market Place for NFTs
![alt=""](NFTImages/BANNER2.png)</br>
## Table of Contents
* [Description](#description)
* [Goals](#project-goals)
* [Data Collection and Preparation](#data-collection-and-preparation)
* [Development and Technologies](#development-and-technologies)
* [Instructions](#instructions)
* [Video Demo](#video-demo)
* [Contributors](#contributors)
* [References and Resources](#references-and-resources)



## Description
---
In this project, we aim to create an NFT marketplace decentralized appliccation (dapp) for the auction of digital assets using smart contracts, solidity and streamlit.

## Goals
---
In recent years, there has been an ever increasing interest in NFTs - As an example, one NFT which was just an image of a column written in New York Times sold for $560,000 in a matter of days. Observing such keen interest in the demand and sale of NFTs as well as the expanding market for digital assets, we felt it would be a great idea to launch our very own T-GRAM Auction Marketplace. 

T-GRAM's goal is to support local and emerging artists and provide them a fast and efficient FinTech platform to register their work and sell them through an auction-based marketplace allowing them to connect with collectors all over the world through a decentralized network.

Our NFT auction marketplace provides:
* A platform that connects artists and collectors through blockchain technology with complete transparency. It holds asset/token/deed that is to be auctioned using ERC721 standards.
* Ability to place bids in auctions, over a decentralized network with following functions and features:
        - ability to participate in an English auction whereby bid prices keep increasing over the duration of the auction.
        - ability to monitor the auction process (start bid, bid price, highest bidder etc.)
        - ability to view the frequency of each bidder
        - ensuring transfer of NFT ownership upon auction completion
        - ensuring safe and accurate transfer of funds upon auction completion
        - Refund of funds to bidders that did not get not lucky
* Use of Polygon Network provided the users with a method that is lower in cost and more efficient as compared to transacting directly over the Ethereum Network (Proof of Stake vs Proof of Work benefits)
* Works with digital assests stored over an established and secure file storage system (IPFS - Pinata)
* T-GRAM does not charge or retain any of the profits from these sales hence providing a free of cost platform for the artists. As opposed to OpenSea, who charge a chunky one-time registration fee to list each NFT as well as recurring fees.


## Data Collection and Preparation
---

In order to test and demo our application we need to have an inventory of digital artwork. We created some custom ones using Photoshop. In order to generate the IPFS links for the custom artwork, we utilized Pinata. 

![alt=""](Images/creation_image.png)</br>

## Development and Technologies
---

Our NFT marketplace is build using the following technologies: 
* Solidity (smart contracts)
* Remix IDE
* Streamlit (frontend)
* MetaMask (wallet)
* Decentralized Blockchain Network (Polygon TestNet/Ganache)
* Xbox GameBar/Quicktime Player (Demo Video)
* ChainLink (new technology/library - not covered in class)
* Pinata
* Photoshop
* Python

![alt=""](Images/solidity_image.png)</br>
![alt=""](Images/remix_image.png)</br>


## Instructions - Environment Preparation
---
### Files:
Download the following files to help you get started:

1. [AuctionRegistry.sol](./Final/AuctionRegistry.sol)
2. [Auction.sol](Final/auction.sol)


### Add Polygon Mumbai Testnet to MetaMask steps:

1. Open MetaMask and select `Settings`
2. Select `Networks`
3. Select `Add Network`
4. Enter Network Name `Matic-Mumbai`
5. Enter New RPC URL `https://rpc-mumbai.maticvigil.com/`
6. Enter Chain ID `80001`
7. Enter Currency Symbol `MATIC`
8. Enter Block Explorer URL `https://mumbai.polygonscan.com/`
9. Add MATIC to accounts via https://faucet.polygon.technology/

### Obtain RPC Server Address

1. Option 1 - Intended Project Blockchain - Polygon Mumbai Test - Create account with https://rpc.maticvigil.com/ and create dapp RPC link for Mumbai Testnet.
2. Option 2 - Backup Project Blockchain - Simply copy RPC Server from Ganache UI.

### Load Keys In .env File

1. Load `PINATA_API_KEY` and `PINATA_SECRET_API_KEY` to .env file for IPFS Hashing and Storage
2. Load `WEB3_PROVIDER_URI` with RPC Server address.
3. Load `SMART_CONTRACT_ADDRESS` according to streamlit dapp. NFTRegistry dapp requires the `NFTRegistry.sol` contract address when deployed from Remix. Auction dapp requires `auction.sol` contract address when deployed from Remix.
4. Load wallet's `MNEMONIC` seed phrase.

### Remix Steps:

To run the application, clone the code from the following GitHub link [git@github.com:tyedem/Project-3.git]. 

1. Compile the `auction.sol` to ensure it compiles without any errors. 

2. Compile the `AuctionRegistry.sol` to ensure it is compiled successfully.

3. Prior to deployment, ensure your MetaMask/wallet is connected and the corresponding item (Injected Web3 for Remix IDE) is selected.

4. Deploy the `auction.sol` and check the deployed contracts to ensure it is there. Copy the address as it would be required for the next step.

5. Add the `auction.sol` contract address to the Deploy the AuctionRegistry.sol and proceed to deploy the AuctionRegistry.sol

6. Use the `auction.sol` address in `AuctionRegistry.sol` deployed contract in the SetApprovalForAll  to the Deploy the AuctionRegistry.sol and proceed to deploy the AuctionRegistry.sol

### streamlit dapp

1. Copy deployed `AuctionRegistry.sol` contract address to SMART_CONTRACT_ADDRESS key in .env file in location of AuctionRegistry dapp. Do the same for `auction.sol`, but in separate .env file in location of Auction dapp. Locations for each captured in below steps
2. Open command line interface terminal
3. For NFTRegistry dapp, navigate to location Project-3/Final/Streamlit_for_registry, then input command `streamlit run app.py`
4. For Auction dapp, navigate to location Project-3/Final/Streamlit_for_registry, then input command `streamlit run app.py`


## Video Demos
---
[Remix Contracts Demo](./Images/Demo)

[Dapp NFT Registry Demo]()

[Dapp Auction Demo]()

# Project Outcome Summary

Though we aimed to achieve a minimum viable product (MVP) within 2 weeks, we were not fully successful in working out every bug we have encountered. Below is a list of known bugs in the current version of T-GRAM's NFT Auction House and some areas to consider for optimizations:

## Optimization and Debugging Opportunities

1. **Polygon (MATIC) Mumbai Testnet** - In Remix, there are no issues deploying to Polygon's Mumbai testnet. However, when running dapp via streamlit, we are unable to successfully load address accounts. Thus, more time would be needed to resolve the dapps operability with Polygon. In order to circumvent the issue with the project as is, loading Ethereum's Ganache testnet is a sufficient solution. Please note, obtaining a MATIC/USD price feed via the `getLatestPrice` call function is only possible when connected to Polygon's Mumbai testnet. Otherwise, this function is operable when connected to Ganache.
2. **Interoperability of streamlit dapps** - The current state of the project has 2 separate dapps. One for registering NFTs only possible via the auction owner and then another one to place bids on NFTs that are registered. However, A programmatic mechanism has not been sufficiently worked out to connect operability of boths dapps seamlessly. Alternatively, considerations may be made to consolidate the dapps into a single frontend platform.
3. **Smart Contract Bug** - `End` Function in `auction.sol` contract does not execute when the auction time has run out and thus leaving the auction open without a means to complete the transfer of NFT ownership and the withdrawal of bid funds to their respective accounts.
4. **Streamlit Bugs** - `Bid` function does not execute correctly for `app3.py`, i.e. our auction dapp. `End` function bug still applies.
___


## Contributors
---
Project Team

<h2><a href="https://github.com/tyedem"><img src="https://avatars.githubusercontent.com/u/90783116?v=4" width=60 /> tyedem</a></h2>

<h2><a href="https://github.com/RiteshChugani"><img src="https://avatars.githubusercontent.com/u/93497343?s=60&" /> RiteshChugani</a></h2>

<h2><a href="https://github.com/1ightray"><img src="https://avatars.githubusercontent.com/u/93296496?v=4" width=60/> 1ightray</a></h2>

<h2><a href="https://github.com/atoosa-m"><img src="https://avatars.githubusercontent.com/u/93611442?v=4" width=60/> atoosa-m</a></h2>

<h2><a href="https://github.com/ksmaria"><img src="https://avatars.githubusercontent.com/u/93277973?s=60&v=4" /> ksmaria</a></h2>


## References and Resources
---
[NFT Sales](https://www.nytimes.com/2021/03/26/technology/nft-sale.html)</br>
[Gas-Free NFT IPFS](https://opensea.io/blog/announcements/decentralizing-nft-metadata-on-opensea/)</br>
[OpenSea Fees](https://support.opensea.io/hc/en-us/articles/1500006315941-What-are-gas-fees-on-Ethereum-)</br>
[dAPP Auction](https://github.com/sbwengineer/auction-dapp-solidity-vue)</br>
[What is Polygon?](https://www.wealthsimple.com/en-ca/learn/what-is-polygon?utm_term=&matchtype=&campaign=16685794737&adgroup=138618658447&gclid=CjwKCAjwx46TBhBhEiwArA_DjH4oks3iZWEumuZnRH1iTbVFVlwNUI9OVcZhZeqe6JPyX30xUS4fChoCJxQQAvD_BwE#the_problem_with_ethereum)</br>
[NFT Auction](https://github.com/techwithtim/Solidity-NFT-Auction)</br>
[NFT Marketplace](https://betterprogramming.pub/solidity-contracts-for-an-nft-marketplace-5a706bb94486)</br>
[NFT Marketplace](https://betterprogramming.pub/solidity-contracts-for-an-nft-marketplace-5a706bb94486)</br>
[ChainLink Price Feed](https://docs.chain.link/docs/get-the-latest-price/)</br>
[OpenZeppelin Contracts Wizard](https://docs.openzeppelin.com/contracts/4.x/wizard) </br>
[OpenZeppelin ERC721 Docs](https://docs.openzeppelin.com/contracts/3.x/api/token/erc721#IERC721-setApprovalForAll-address-bool-)</br>



Copyright © 2022# Project-3

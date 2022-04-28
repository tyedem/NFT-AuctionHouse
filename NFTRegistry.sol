// SPDX-License-Identifier: MIT
pragma solidity ^0.5.5;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";

contract NFTRegistry is ERC721Full {
    address contractAddress;
    
    constructor(address marketplaceAddress) public ERC721Full("NFTToken", "NFT") {
        contractAddress = marketplaceAddress;
    }

    struct NFT {
        string name;
        string owner;
        uint256 appraisalValue;
    }

    mapping(uint256 => NFT) public NFTCollection;

    event Appraisal(uint256 tokenId, uint256 appraisalValue, string reportURI);

    function registerNFT(
        address owner,
        string memory name,
        string memory creator,
        uint256 initialAppraisalValue,
        string memory tokenURI
    ) public returns (uint256) {
        uint256 tokenId = totalSupply();

        _mint(owner, tokenId);
        _setTokenURI(tokenId, tokenURI);

        NFTCollection[tokenId] = NFT(name, creator, initialAppraisalValue);

        return tokenId;
    }

    function newAppraisal(
        uint256 tokenId,
        uint256 newAppraisalValue,
        string memory reportURI
    ) public returns (uint256) {
        NFTCollection[tokenId].appraisalValue = newAppraisalValue;

        emit Appraisal(tokenId, newAppraisalValue, reportURI);

        return NFTCollection[tokenId].appraisalValue;
    }
}
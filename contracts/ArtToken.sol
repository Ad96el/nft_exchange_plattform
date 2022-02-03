// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.8.0;
pragma experimental ABIEncoderV2;

import "./ERC721.sol";

contract ArtToken is ERC721 {


    string public collectionName;
    // this contract's token symbol
    string public collectionNameSymbol;
    // total number of crypto boys minted
    uint256 public artCounter;

    struct token {
        uint256 tokenId; 
        string name; 
        string tokenURI; 
        address payable mintedBy; 
        address payable currentOwner; 
        address payable previousOwner; 
        uint256 price; 
        bool forSale; 
    }

    mapping(uint256 => token) public allTokens; 
    mapping(string => bool) public tokenNameExits; 
    mapping(string => bool) public tokenURIExits; 


    constructor() ERC721("ArtToken Collection" , "AT") public {
        collectionName = name(); 
        collectionNameSymbol= symbol();
    }

    function mint(string calldata _name , string calldata _tokenURI, uint256 _price, bool _sale ) external {
        require(msg.sender != address(0)); 

        artCounter ++;
        
        require( !_exists(artCounter)  , "token does exists" );
        require (! tokenURIExits[_tokenURI]  , "URL does exists");
        require (! tokenNameExits[_name] , "name already selected");

        _mint(msg.sender, artCounter); 
        _setTokenURI(artCounter, _tokenURI); 

        tokenURIExits[_tokenURI] = true; 
        tokenNameExits[_name] = true; 

        token memory newArtToken = token(
            artCounter, 
            _name,
            _tokenURI,
            msg.sender, 
            msg.sender,
            address(0),
            _price, 
            _sale
        );

        allTokens[artCounter] = newArtToken;

    }

    function getTotalSupply() public view returns(uint256) {
        return artCounter;
    }

    function getTokenById(uint256 id) public view returns(token memory) {
        require (_exists(id) , "token does not exists" );
        return allTokens[id];
    }

    function changeTokenPrice(uint256 _id , uint256 newPrice) public { 

        require( _exists(_id));
        require( msg.sender != address(0));
        token memory currentToken = allTokens[_id];
        require(currentToken.currentOwner == msg.sender);
        currentToken.price = newPrice; 
        allTokens[_id] = currentToken;

    }

    function setSaleSaleState (uint256 _id , bool sale) public { 

        require( _exists(_id));
        require( msg.sender != address(0));
        token memory currentToken = allTokens[_id];
        require(currentToken.currentOwner == msg.sender);
        currentToken.forSale = sale; 
        allTokens[_id] = currentToken;

    } 

    function buyToken(uint256 _id) public payable{
        require(msg.sender != address(0));
        require(_exists(_id));
        token memory currentToken = allTokens[_id];
        require(msg.sender != currentToken.currentOwner , "owner cannot buy his own token" );

        require(msg.value >= currentToken.price , "Price to low");

        require(currentToken.forSale , "Token is not for sale");

        address tokenOwner = ownerOf(_id);

        _transfer(tokenOwner, msg.sender, _id); 

        address payable sendTo = currentToken.currentOwner; 

        sendTo.transfer(msg.value); 

        currentToken.previousOwner = currentToken.currentOwner; 
        currentToken.currentOwner = msg.sender; 
        
        allTokens[_id] = currentToken;

    }
 



}
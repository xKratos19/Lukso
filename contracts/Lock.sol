// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "@lukso/lsp-smart-contracts/contracts/LSP8IdentifiableDigitalAsset/LSP8IdentifiableDigitalAsset.sol";

contract Recycle is LSP8IdentifiableDigitalAsset{

    constructor(
    string memory name_,
    string memory symbol_,
    address newOwner_
    ) LSP8IdentifiableDigitalAsset(name_,symbol_,newOwner_){}

    uint256 generatedTags = 1;
    mapping(uint256=>bytes32) ProductKey;
    mapping(bytes32=>uint256) ProductCheck;
    mapping(uint256=>string) ProductMaterial;

    event newProduct(address _from, uint256 _indexedId, string material, uint _time);
    event customerClaim(address _from, address _to, bytes32 _tokenId, uint _time);
    
    
    function generateManufacturer(address _to, string memory _material) public{
        _mint(_to,bytes32(generatedTags),true,"");
        ProductKey[generatedTags] = generateHash(convertUintToBytes(generatedTags));
        ProductCheck[ProductKey[generatedTags]] = generatedTags;
        ProductMaterial[generatedTags] = _material;
        emit newProduct(_to,generatedTags, _material, block.timestamp);
        generatedTags++;

    }

    function generateHash(bytes memory _data) public pure returns (bytes32) {
        return keccak256(_data);
    }

    function logisticCheck(address _from,address _to,bytes32 _tokenId) public {
        require(bytes32(ProductCheck[bytes32(_tokenId)]) == ProductKey[uint256(_tokenId)],"Wrong Product Key");

        _transfer(_from, _to, _tokenId, true, "");
        emit customerClaim(_from,_to,_tokenId,block.timestamp);
        productKeyBurn(uint256(_tokenId));

    } 

    function customerRequest(address _to,bytes32 _tokenId) public {
        address transferAddress = tokenOwnerOf(_tokenId);
        _transfer(transferAddress, _to, _tokenId, true, ""); //i need to make a security gate
    }

    function productKeyBurn(uint256 _tokenId) public{
        ProductKey[_tokenId] = 0;
    }

    function tagBurn(bytes32 _tokenId) public{
        _burn(_tokenId,"");
    }


    function totalMinted() public view returns(uint256){
        return generatedTags;
    }

    function tagFinder(address _owner) public view returns(bytes32[] memory){
        return tokenIdsOf(_owner);
    }

    function tagIdFinder(bytes32 _tokenId) public view returns(address){
        return tokenOwnerOf(_tokenId);
    }

    function returnProductKey(uint256 _tokenId) public view returns(bytes32) {
        return ProductKey[_tokenId];
    }

    function returnProductCheck(bytes32 _tokenId) public view returns(uint256){
        return ProductCheck[_tokenId];
    }

    function convertUintToBytes(uint256 _value) public pure returns (bytes memory) {
        return abi.encode( _value );
    }


    }

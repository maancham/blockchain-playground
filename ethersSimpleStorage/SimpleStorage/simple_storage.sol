// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleStorage {
    bytes20 CatName = "snippy";
    uint128 public favNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;

    mapping(string => uint256) public nameToFavoriteNumber;
    
    function storeFav(uint128 _favNumber) public virtual  {
        favNumber = _favNumber;
        retrieve();
    }

    function retrieve() public view returns(uint128) {
        return favNumber;
    }

    function addPerson(string memory _name, uint256 _favNumber) public {
        people.push(People(_favNumber, _name));
        nameToFavoriteNumber[_name] = _favNumber;
    }

}
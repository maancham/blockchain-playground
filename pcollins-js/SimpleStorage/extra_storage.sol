// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./simple_storage.sol"; 

contract ExtraStorage is SimpleStorage {
    
    function storeFav(uint128 _favNumber) public override  {
        favNumber = _favNumber + 6;
    }

}
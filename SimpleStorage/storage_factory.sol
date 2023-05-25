// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.18;

import "./simple_storage.sol"; 

contract StorageFactory {
    
    SimpleStorage[] public simpleStorageArray;
    
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }
    
    function sfStore(uint128 _simpleStorageIndex, uint128 _simpleStorageNumber) public {
        // Address 
        // ABI
        simpleStorageArray[_simpleStorageIndex].storeFav(_simpleStorageNumber);
    }
    
    function sfGet(uint128 _simpleStorageIndex) public view returns (uint128) {
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }
}
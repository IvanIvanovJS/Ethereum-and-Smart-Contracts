// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {

    SimpleStorage[] public listOfsimpleStorage;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfsimpleStorage.push(newSimpleStorageContract);
    }

    function sfStore (uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {
        //Address
        //ABI
        SimpleStorage mySimpleStorage = listOfsimpleStorage[_simpleStorageIndex];
        mySimpleStorage.store(_newSimpleStorageNumber);
    }

    function sfGet (uint256 _simpleStorageIndex) public view returns(uint256) {
        //Address
        //ABI
        SimpleStorage mySimpleStorage = listOfsimpleStorage[_simpleStorageIndex];
        return mySimpleStorage.retrieve();
    }
}
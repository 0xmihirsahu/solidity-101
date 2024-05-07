// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {CarStorage} from "./CarStorage.sol";

contract CarFactory{
    CarStorage[] public listOfCarStorageContracts;

    function createCarStorage(uint256 _dealerId) public {
        CarStorage newCarStorage = new CarStorage(_dealerId);
        listOfCarStorageContracts.push(newCarStorage);
    }

    function sfSetBalance(uint256 _carStorageIndex, uint256 _newBalance) public {
        listOfCarStorageContracts[_carStorageIndex].setBalance(_newBalance);
    }

    function sfGetBalance(uint256 _carStorageIndex) public view returns(uint256 _balance){
        return listOfCarStorageContracts[_carStorageIndex].getBalance();
    }
}
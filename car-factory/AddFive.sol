// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {CarStorage} from "./CarStorage.sol";

contract AddFive is CarStorage{

    constructor(uint256 _dealerId) CarStorage(_dealerId){}

    function setBalance(uint256 _newBalance) public override  {
        accountBalance = _newBalance + 5;
    }
}
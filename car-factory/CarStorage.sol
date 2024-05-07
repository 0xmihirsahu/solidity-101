//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CarStorage{
    uint256 public dealerId;
    address public dealerAddress;
    uint256 public accountBalance;

    constructor(uint256 _dealerId){
        dealerAddress = msg.sender;
        dealerId = _dealerId;
    }

    struct Car{
        string brandName;
        uint128 registrationNumber;
        bool isElectric;
        uint32 topSpeed;
    }

    mapping(string => uint32) public carToTopSpeed;
    mapping(string => bool) public carToIsElectric;
    mapping(string => uint128) public carToRegistrationNUmber;

    Car[] public listOfCars;

    function addCar(string memory _brandName, uint128 _registrationNumber, bool _isElectric, uint32 _topSpeed) public{
        require(msg.sender == dealerAddress, "You are not the dealer.");
       listOfCars.push(Car({brandName: _brandName, registrationNumber: _registrationNumber, isElectric: _isElectric, topSpeed: _topSpeed}));
       carToTopSpeed[_brandName] = _topSpeed;
       carToIsElectric[_brandName] = _isElectric;
       carToRegistrationNUmber[_brandName] = _registrationNumber;
    }

    function getDealerId() public view returns (uint256 _dealerId){
        return dealerId;
    }

    function setBalance(uint256 _accountBalance) virtual  public {
        accountBalance = _accountBalance;
    }

    function getBalance() public view returns(uint256){
        return accountBalance;
    }
}
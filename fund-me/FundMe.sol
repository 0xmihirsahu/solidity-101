//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import { PriceConvertor} from "fund-me/PriceConvertor.sol";

// error NotOnwer();

contract FundMe {

  using PriceConvertor for uint256;

    uint256 public constant MINIMUM_USD = 5 * 1e18;
    address[] public funders;
    address public immutable i_owner;

    constructor(){
      i_owner = msg.sender;
    }

    // if eth is sent to contract without any msg.data and if recieve is not defined then fallback gets called
    receive() external payable {
        fund();
    }

    // if eth is sent to contract with unknown msg.data
    fallback() external payable { 
        fund();
    }

    modifier onlyOwner (){
        require(msg.sender == i_owner,"Sender is not owner");
        _;
        // if _; is above require statement 
        // then the function gets executed first then modifier gets executed 

        // more gas effecient way
        // if(msg.sender != i_owner) { revert NotOwner();}
    }

    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;
    event FundsWithdrawn(address _to, uint256 _amount);

    function fund() public payable{
        require(msg.value.getConversionRate() >= MINIMUM_USD,"didn't send enough ether");

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw(address payable  _reciever, uint256 _amount) public onlyOwner{
      require(address(this).balance >= _amount, "Not enough funds to withdraw");

      // setting the mapping to zero
      for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
        address funder = funders[funderIndex];
        addressToAmountFunded[funder] = 0;
      }

      // resetting the array by creating new array
      funders = new address[](0);

      // There are three ways to send ETH:
      // 1. transfer - this throwss error if fails
      // _reciever.transfer(_amount);

      // 2. send - this throws bool if fail so we can use it in require and revert the transaction
      // bool sendSuccess = _reciever.send(_amount);
      // require(sendSuccess, "Send failed");

      // 3. call - like a regular transaction
      // (bool callSuccess, bytes memory dataReturned) = _reciever.call{value: _amount}("");
      (bool callSuccess, ) = _reciever.call{value: _amount}("");
      require(callSuccess, "Call failed");

      emit FundsWithdrawn(_reciever, _amount);
    }
}
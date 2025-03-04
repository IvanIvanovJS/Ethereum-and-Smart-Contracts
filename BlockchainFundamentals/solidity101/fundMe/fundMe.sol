// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./priceConverter.sol";
contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18; 

    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;
    address public owner;
    constructor (){
        owner = msg.sender;
    }

    function fund() public payable {
        
       require(msg.value.getConversationRate() > MINIMUM_USD,"You must send more than the minimum");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;

    }
    function withdraw () public onlyOwner{
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0 ;
            funders = new address[](0);
            (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
            require(success, "Call failed");
        }
    }
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }
    
}
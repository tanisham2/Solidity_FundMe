// SPDX-License-Identifier: MIT
// gas used to create the contract: 782,556
// to bring gas price down; we use 2 keywords: constant, immutable
// after using constant: 762,243
// after using immutable: 739,480
pragma solidity ^0.8.18;

import {PriceConvertor} from "./PriceConvertor.sol";

error NotOwner();
contract FundMe {
    using PriceConvertor for uint256; 

    uint256 public constant MIN_USD = 50 * 1e18;   //1 * 10 ** 18
                                                      //using constant: 21,415 gas (execution cost, MIN_USD)
                                                      // without using: 23,515 gas

    address[] public funders; //create array of funders
    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;          //variable
                                                                                            //maps the funders w the amount they funded

    address public i_owner;
    // using immutable: 21,508
    // without using: 23,644
    
    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        //msg.value.getConversionRate();
       //allow users to send money
       //have a minimum $ sent
       require (msg.value.getConversionRate() >= MIN_USD, "Did not send enough Eth"); //1e18 = 1 ETH = 1 * 10 ** 18 = 100000000000000000
        //force senders to send atleast 1 ETH during the transaction
       funders.push(msg.sender);
       addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
        //keeps tracks of funders by adding the new amount they fund after funding previously
    }
    function withdraw() public onlyOwner {
        uint256 funderIndex;
        for (funderIndex=0; funderIndex<funders.length; funderIndex++) {
            //sets everything back to 0 when they are withdrawing money from the fund
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
       funders =  new address[](0);  // resets array to 0
// Methods to withdraw money: 1. transfer
        // payable(msg.sender).transfer(address(this).balance);

        // 2. send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        //3. call (MOST USED)
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {                       //will execute whats in this modifier first
        //require(msg.sender == i_owner, "SENDER IS NOT OWNER!!");
        if (msg.sender != i_owner) {
            revert NotOwner(); 
        }        
        _;                                       //adds whatever else is in the function 
    } 
                                                 //what happens if somebody accidently sends this contract ETH w/o calling the fund() function
                                                //Ether is sent to contract
    receive() external payable {
        fund();
    }
    fallback() external payable {
        fund();
    }
} 












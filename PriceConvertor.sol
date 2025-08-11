// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConvertor{
    function getPrice() internal view returns(uint256) {
    //get price of Eth in terms of USD
    //get the value from documentation: docs.chain.link> chainlink data feeds > feed addresses> price feed addresses
    // we need:
    // Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
    //ABI: 
    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);   //priceFeed: variable
    (,int256 price,,,) = priceFeed.latestRoundData();
    //price of ETH in terms of USD (like 200000000)
    return uint256(price * 10);   //typecasting
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        //lets say we convert 1ETH
        //dollars= 2000_10^18
        uint256 ethPrice = getPrice();
        // (2000_10^18 * 1_10^10) / 1e18;
        // $2000 = 1 ETH;
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUSD;
    }
    //convert ETH value to USD

    function getVersion() internal view returns (uint256){
         return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract FundMe {

    uint128 public minUSD = 50 * 1e18;
    address[] public funders;
    mapping (address => uint256) public addressAmountFunded;


   // get funding from others, everyone can call it
   function fund() public payable {

       // need the incoming value to be at least 0.01 ETH
       require(getConversionRate(msg.value) >= minUSD, "Not Enough Funds!");
       // if reverted, all state changes are reset and return remaining gas
       funders.push(msg.sender);
       addressAmountFunded[msg.sender] = msg.value;
   }

   function getPrice() public view returns (uint256) {
        // need two things, ABI and Address of the destination contract
        // Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI can be view as endpoint/function names
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 1e10);

   }

   function getAggVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
   }

   function getConversionRate(uint256 ethAmount) public view returns (uint256) {
       uint256 ethPrice = getPrice();
       uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
       return ethAmountInUSD;
   }

   // withdraw funds to wallet
//    function withdraw() {}
}
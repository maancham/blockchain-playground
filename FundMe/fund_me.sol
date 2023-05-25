// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./price_converter.sol";

error NotOwner();

// original gas used: 799630 
contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant minUSD = 50 * 1e18;
    address[] public funders;
    mapping (address => uint256) public addressAmountFunded;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

   // get funding from others, everyone can call it
   function fund() public payable {
       require(msg.value.getConversionRate() >= minUSD, "Not Enough Funds!");
       // if reverted, all state changes are reset and return remaining gas
       funders.push(msg.sender);
       addressAmountFunded[msg.sender] = msg.value;
   }


   // withdraw funds to wallet, only owner can call it
   function withdraw() public onlyOwner  {
       for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            addressAmountFunded[funders[funderIndex]] = 0;
        }
        funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
   }


    // to handle incoming txs with funds that do not call fund()
    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}
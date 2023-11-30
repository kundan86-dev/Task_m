// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

interface tkA {
    function getTokenPrice() external view returns(uint256);
}

contract TokenMarketplace is Ownable {
    AggregatorV3Interface public priceFeed;
    IERC20 public token2;
    IERC20 public tokenA;
    tkA public Tokena;
    uint256 public tokenPriceInUSD = 202715000000;


    constructor(address tokenAddress, address tokenA1d) {
        // constructor() {
        token2 = IERC20(tokenAddress);
        tokenA = IERC20(tokenA1d);
        Tokena = tkA(tokenA1d);
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function setTokenPriceFromChainlink() public onlyOwner {
       tokenPriceInUSD = getEtherPriceInUSD();
    }

    function getEtherPriceInUSD() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint256 usdPrice = uint256(price);
        return  usdPrice;
    }

    function buyTokens() public payable {
        require(msg.value > 0, "Send some Ether to buy tokens");
        address buyer = msg.sender;
        uint256 ethAmount = msg.value;
        uint256 tokenAmount = (ethAmount*(10**5) / (tokenPriceInUSD))* (1 ether); //203140520000
        // uint256 tokenAmount = ((ethAmount*(10**5)/(202715000000))* (1 ether));
        console.log(tokenAmount);

        (bool sent) = token2.transfer(buyer, tokenAmount);
        require(sent, "Token transfer failed");
    }

    function swapTokens(uint tokenAmount) public {
        uint tokenAPrice = Tokena.getTokenPrice();
        uint paidValue = tokenAPrice*tokenAmount * 10**13;
        uint tokenToSend = (paidValue/tokenPriceInUSD)*1 ether;
        tokenA.transferFrom(msg.sender,address(this), tokenAmount);
        token2.transfer(msg.sender, tokenToSend);
    }
}

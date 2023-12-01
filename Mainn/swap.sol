// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./tokenB.sol";

contract Swap is Ownable {
    uint public conversionRate = 80;
    AggregatorV3Interface public usdtPriceFeed;
    uint public goldPrice;
    address public myTokenBAddress;

    constructor(uint _initialGoldPrice, address _myTokenBAddress) {
        usdtPriceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        goldPrice = _initialGoldPrice;
        myTokenBAddress = _myTokenBAddress;
    }

    function setGoldPrice(uint _newGoldPrice) external onlyOwner {
        require(_newGoldPrice > 0, "Invalid gold price");
        goldPrice = _newGoldPrice;
    }

    function setConversionRate() external {
        // Fetch the token price from MyTokenB contract
        uint256 tokenBPrice = MyTokenB(myTokenBAddress).tokenPriceInUSD();

        // Use the fetched token price to calculate conversion rate
        conversionRate = goldPrice * 100 / tokenBPrice;
    }

    function swapTokensGoldToUSDT(address _tokenIn, uint256 _amountIn) external {
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn * 10**6);

        uint256 amountOut = (_amountIn * conversionRate) / 100;

        IERC20(myTokenBAddress).transfer(msg.sender, amountOut * 10**6);
    }

    function swapUSDTToGold(address _tokenIn, uint256 _amountIn) external {
        IERC20(myTokenBAddress).transferFrom(msg.sender, address(this), _amountIn * 10**6);

        uint256 amountOut = (_amountIn * 100) / conversionRate;

        IERC20(_tokenIn).transfer(msg.sender, amountOut * 10**6);
    }

    function getGoldPrice() external view returns (uint) {
        return goldPrice;
    }

    function getUsdPrice() external view returns (uint) {
        (, int256 usdtPrice, , , ) = usdtPriceFeed.latestRoundData();
        require(usdtPrice > 0, "Invalid USD price from Chainlink");
        return uint256(usdtPrice) / 10**8;
    }
}
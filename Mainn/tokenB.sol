// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract MyTokenB is ERC20, ERC20Burnable, Ownable {
    uint256 public tokenPriceInUSD=2031;

    AggregatorV3Interface public priceFeed;

    constructor() ERC20("USD Token", "USDT") {
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        _mint(msg.sender, 10000000 * 10**decimals());
    }

    function setTokenPriceFromChainlink() public onlyOwner {
        tokenPriceInUSD = getEtherPriceInUSD();
    }

    function getEtherPriceInUSD() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint256 usdPrice = uint256(price); // 10**8;
        return usdPrice;
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount * 100**6);
    }

   function buyTokenB() public payable {
    require(msg.value > 0, "eth required");

    // Calculate the number of tokens based on the Ether value and token price
    uint256 numberOfTokens = (msg.value * tokenPriceInUSD) / (1 ether);

    // Mint the calculated number of tokens to the buyer
    _mint(msg.sender, numberOfTokens * 10**6);
}


}

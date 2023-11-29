// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenUSDT is ERC20, Ownable {

    AggregatorV3Interface public priceFeed;
      address public admin;

    constructor(address _priceFeed) ERC20("USDT Token", "USDT") {
        priceFeed = AggregatorV3Interface(_priceFeed);
          admin=msg.sender;
         _mint(msg.sender, 10000 * (10**18));
    }

    // Automatically update the token price, only callable by the owner
    function updateTokenPrice() external onlyOwner {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint256 usdtAmount = uint256(price); // You may need to adjust the conversion based on your specific needs
        _setTokenPrice(usdtAmount);
    }

    function _setTokenPrice(uint256 _price) internal {
        require(_price > 0, "Invalid price");
        _mint(msg.sender, _price); // Mint tokens based on the obtained price
    }

    function getTokenPriceB() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price);
    }

      
   function buyTokenA(uint noOfToken) public payable {
        require(msg.value > 0, "Send some Ether to buy tokens");
        uint tokenPrice = getTokenPriceB()/10**5;
        // uint tokenPrice = 2;
        uint requiredAmount = (noOfToken * tokenPrice) ;
        require(msg.value == requiredAmount*1 ether, "Amount is less");
        _transfer(admin, msg.sender, noOfToken*10**18);
    }

}

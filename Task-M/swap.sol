// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Erc20.sol";
import "./priceOfUsdt.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {

    address public admin;
    TokenA public tokenA;
    TokenUSDT public usdtPriceFeed;

    constructor(address _tokenAAddress, address _usdtPriceFeedAddress) {
        admin = msg.sender;
        tokenA = TokenA(_tokenAAddress);
        usdtPriceFeed = TokenUSDT(_usdtPriceFeedAddress);
    }

    modifier onlyAdmin() {
        require(admin == msg.sender, "Not authorized: You are not Admin");
        _;
    }

    function swapTokenAforUSDT(address recipient, uint256 amount) external onlyAdmin {
    uint256 tokenPrice = usdtPriceFeed.getTokenPriceB();
    uint256 usdtAmount = (amount * tokenPrice) / 1e18;

    require(tokenA.transferFrom(msg.sender, address(this), amount), "Transfer from TokenA failed");

    // Assuming usdtTokenAddress is the address of the USDT token contract
    address usdtTokenAddress = 0xYourUsdtTokenAddress; // Replace with the actual address
    IERC20(usdtTokenAddress).transfer(recipient, usdtAmount);
}

}

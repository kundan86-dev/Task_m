// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ITokenA {
    function returnPriceOFTokenA() external view returns (uint256);
}

contract TokenSwap is Ownable {
      using SafeERC20 for IERC20;
   
    mapping(address => bool) public supportedTokens;

    modifier onlySupportedTokens(address token) {
        require(supportedTokens[token], "Token not supported");
        _;
    }

    function addSupportedToken(address token) external onlyOwner {
        supportedTokens[token] = true;
    }

    // Swap TokenA for TokenUSDT based on TokenA's price
    function swapTokenAForTokenUSDT(address tokenA, address tokenUSDT, uint256 amount) external onlySupportedTokens(tokenA) onlySupportedTokens(tokenUSDT) {
        uint256 tokenAPrice = TokenA(tokenA).returnPriceOFTokenA();
        uint256 usdtAmount = (amount * tokenAPrice) / 10**18;

        // Ensure the user has enough TokenA balance
        require(IERC20(tokenA).balanceOf(msg.sender) >= amount, "Insufficient TokenA balance");

        // Transfer TokenA from the sender to the contract
        IERC20(tokenA).safeTransferFrom(msg.sender, address(this), amount);

        // Transfer equivalent amount of TokenUSDT to the sender
        IERC20(tokenUSDT).safeTransfer(msg.sender, usdtAmount);
    }

    // Swap TokenUSDT for TokenA based on TokenA's price
    function swapTokenUSDTForTokenA(address tokenA, address tokenUSDT, uint256 usdtAmount) external onlySupportedTokens(tokenA) onlySupportedTokens(tokenUSDT) {
        uint256 tokenAPrice = TokenA(tokenA).returnPriceOFTokenA();
        uint256 amount = (usdtAmount * 10**18) / tokenAPrice;

        // Ensure the user has enough TokenUSDT balance
        require(IERC20(tokenUSDT).balanceOf(msg.sender) >= usdtAmount, "Insufficient TokenUSDT balance");

        // Transfer TokenUSDT from the sender to the contract
        IERC20(tokenUSDT).safeTransferFrom(msg.sender, address(this), usdtAmount);

        // Transfer equivalent amount of TokenA to the sender
        IERC20(tokenA).safeTransfer(msg.sender, amount);
    }
}

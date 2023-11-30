// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./tokenA.sol";
import "./Token.sol";

contract TokenSwap {
    TokenA public tokenA;
    TokenB public tokenB;

    constructor(TokenA _tokenA, TokenB _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    
    
    function swapTokensWithUser(address userB,uint256 amountA) external {
            uint256  priceA = tokenA.returnPriceOFTokenA();
            uint256 priceB = tokenB.getFixedTokenPrice();
    
        // Calculate the equivalent amount of TokenB based on the price ratio
        uint256 amountB = (amountA * priceA) / priceB;

        //Ensure the sender has enough balance and allowance for TokenA
        require(tokenA.balanceOf(msg.sender) >= amountA, "Insufficient balance of TokenA");
        require(tokenA.allowance(msg.sender, address(this)) >= amountA, "Insufficient allowance for TokenA");

        // Ensure userB has enough allowance for TokenA from the sender
        require(tokenA.allowance(msg.sender, userB) >= amountA, "Insufficient allowance for TokenA from the sender to userB");

        // Ensure userB has enough balance and allowance for TokenB
        require(tokenB.balanceOf(userB) >= amountB, "Insufficient balance of TokenB for userB");
        require(tokenB.allowance(userB, msg.sender) >= amountB, "Insufficient allowance for TokenB from userB to the sender");

        // Transfer tokens directly between users
        tokenA.transferFrom(msg.sender, userB, amountA);
        tokenB.transferFrom(userB, msg.sender, amountB);
    }
}

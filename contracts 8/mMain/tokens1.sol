// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20,Ownable {

    uint256 public tokenPriceInWei;

    constructor()  ERC20("MYTOKEN","MYTKN"){
     _mint(msg.sender, 10000000000000000000000000000000000000000000000*10**18);
        
    }
    function mint(address add) public {
         _mint(msg.sender, 1000000000000000000000000000000000*10**18);
    }

    function setTokenPrice(uint256 newPrice) public onlyOwner {
        tokenPriceInWei = newPrice;
    }
    
    function getTokenPrice() public view returns (uint256) {
        return tokenPriceInWei;
    }

    function buyTokens() public payable {
        require(msg.value > 0, "Send some Ether to buy tokens");
        address buyer = msg.sender;
        uint256 ethAmount = msg.value;
        uint256 tokenAmount = ethAmount / (tokenPriceInWei * 1 gwei);       
        mint(buyer);
    }

  

}
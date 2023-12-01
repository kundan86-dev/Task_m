// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract MyTokenA is ERC20,ERC20Burnable,Ownable {

    uint256 public  tokenPrice;

    constructor() ERC20("Gold Token", "GTK") {
        _mint(msg.sender, 10000000*10** decimals());
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }
    

    function mint(address to, uint256 amount) public  {
        _mint(to, amount*100**6);
    }
    
      function setTokenPrice(uint256 newPrice) public onlyOwner  {
        tokenPrice = newPrice;
    }
    
    function getTokenPrice() public view returns (uint256) {
        return tokenPrice;
    }

    function buyTokenA() public payable {
        require(msg.value > 0,"eth required");
        _mint(msg.sender, ((tokenPrice*msg.value)/ 1 ether)*10**6);
    }
}
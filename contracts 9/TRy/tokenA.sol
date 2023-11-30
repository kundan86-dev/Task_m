// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenA is ERC20, Ownable {

    address public admin;
    uint256 public tokenPriceInWei;

    constructor() ERC20("MY_TOKEN", "MTK") {
        admin = msg.sender;
        _mint(msg.sender, 10000 * (10**18));
    }  

    modifier onlyAdmin() {
        require(owner() == msg.sender, "Not authorized: You are not Admin");
        _;
    }

    function addMoreTokens(uint _numberOfTokens) public{
      _mint(msg.sender, _numberOfTokens * (10**18));
   }

    function setPriceOFTokenA(uint256 _price) public onlyAdmin {
        tokenPriceInWei = _price;
    }

    function returnPriceOFTokenA() public view returns(uint256) {
        return tokenPriceInWei;
    }

  function buyTokens() public payable {
        require(msg.value > 0, "Send some Ether to buy tokens");
        address buyer = msg.sender;
        uint256 ethAmount = msg.value;
        uint256 tokenAmount = ethAmount / (tokenPriceInWei * 1 gwei);       
        _transfer(admin, buyer, tokenAmount * 10**18);
    }

}
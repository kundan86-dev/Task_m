// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract TokenA is ERC20, Ownable{

    address public admin;
    uint256 tokenPrice;

   constructor() ERC20("MY_TOKEN", "T_K"){
     admin=msg.sender;
    _mint(msg.sender, 10000 * (10**18));

    }  
    modifier onlyAdmin(){
        require(owner()==msg.sender,"Not authorized:You are not Admin");
        _;
    }

    function setPriceOFTokenA(uint256 _price) public onlyAdmin{
        tokenPrice=_price;
    }

    function returnPriceOFTokenA () public view returns(uint256){
        return tokenPrice;
    }
    
   function buyTokenA(uint noOfToken) public payable {
        require(msg.value > 0, "Send some Ether to buy tokens");
        uint requiredAmount = (noOfToken * tokenPrice) ;
        require(msg.value == requiredAmount*1 ether, "Amount is less");
        _transfer(admin, msg.sender, noOfToken*10**18);
    }
    
}


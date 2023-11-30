// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20,Ownable {
    constructor()  ERC20("MYTOKEN","MYTKN"){
     _mint(msg.sender, 10000000000000000000000000000000000000000000000*10**18);
        
    }

}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenB is ERC20, Ownable {

    uint256 public constant FIXED_TOKEN_PRICE = 20;

    constructor() ERC20("MY_FIXED_TOKEN", "FTK") {
        _mint(msg.sender, 10000 * (10**18));
    }

    modifier onlyAdmin() {
        require(owner() == msg.sender, "Not authorized: You are not Admin");
        _;
    }

    function buyTokens() public payable {
        require(msg.value > 0, "Send some Ether to buy tokens");
        address buyer = msg.sender;
        uint256 ethAmount = msg.value;
        uint256 tokenAmount = ethAmount / FIXED_TOKEN_PRICE;

        _transfer(owner(), buyer, tokenAmount * 10**18);
    }

    function transferTokens(address to, uint256 amount) external onlyAdmin {
        _transfer(msg.sender, to, amount);
    }

    function getFixedTokenPrice() public pure returns (uint256) {
        return FIXED_TOKEN_PRICE;
    }
}
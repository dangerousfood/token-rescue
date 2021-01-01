//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenRescue is Ownable {

  mapping(address => bool) private restricted;

  function addRestricted(address token) onlyOwner external {
    restricted[token] = true;
  }

  modifier isNotRestricted(address token) {
    require(token != owner(), "token provided is the owner contract");
    require(!restricted[token], "token provided is on the restricted list");
    _;
  }

  function transfer(address addr, address recipient, uint256 amount) onlyOwner isNotRestricted(addr) external returns (bool) {
    IERC20 token = IERC20(addr);
    return token.transfer(recipient, amount);
  }

  function allowance(address addr, address owner, address spender) onlyOwner isNotRestricted(addr) external view returns (uint256) {
    IERC20 token = IERC20(addr);
    return token.allowance(owner, spender);
  }

  function approve(address addr, address spender, uint256 amount) onlyOwner isNotRestricted(addr) external returns (bool) {
    IERC20 token = IERC20(addr);
    return token.approve(spender, amount); 
  }

  function transferFrom(address addr, address sender, address recipient, uint256 amount) onlyOwner isNotRestricted(addr) external returns (bool) {
    IERC20 token = IERC20(addr);
    return token.transferFrom(sender, recipient, amount);
  }
}

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
    require(token != address(this), "token address that inherits TokenRescue cannot be interacted with");
    require(!restricted[token], "token address provided is on the restricted list");
    _;
  }

  function rTransfer(address addr, address recipient, uint256 amount) onlyOwner isNotRestricted(addr) external returns (bool) {
    IERC20 token = IERC20(addr);
    return token.transfer(recipient, amount);
  }

  function rAllowance(address addr, address owner, address spender) onlyOwner isNotRestricted(addr) external view returns (uint256) {
    IERC20 token = IERC20(addr);
    return token.allowance(owner, spender);
  }

  function rApprove(address addr, address spender, uint256 amount) onlyOwner isNotRestricted(addr) external returns (bool) {
    IERC20 token = IERC20(addr);
    return token.approve(spender, amount); 
  }

  function rTransferFrom(address addr, address sender, address recipient, uint256 amount) onlyOwner isNotRestricted(addr) external returns (bool) {
    IERC20 token = IERC20(addr);
    return token.transferFrom(sender, recipient, amount);
  }
}

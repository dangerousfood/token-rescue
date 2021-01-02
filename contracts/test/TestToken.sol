//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20 {

  constructor() ERC20("TestToken", "TT") { }

  function mint(address account, uint256 amount) public virtual {
    _mint(account, amount);
  }
} 
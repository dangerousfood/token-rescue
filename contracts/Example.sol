//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TokenRescue.sol";

contract Example is ERC20, TokenRescue {

  constructor() ERC20("Example", "EXP") { }

  function mint(address account, uint256 amount) public virtual {
    _mint(account, amount);
  }
} 
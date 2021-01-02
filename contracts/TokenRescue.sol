//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

// import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/GSN/Context.sol";

contract TokenRescue is Context {

  mapping(address => bool) private restricted;

  function addRestricted(address token) onlyRescueOwner external {
    restricted[token] = true;
  }

  modifier isNotRestricted(address token) {
    require(token != address(this), "token address that inherits TokenRescue cannot be interacted with");
    require(!restricted[token], "token address provided is on the restricted list");
    _;
  }

  function rTransfer(address addr, address recipient, uint256 amount) onlyRescueOwner isNotRestricted(addr) external returns (bool) {
    IERC20 token = IERC20(addr);
    return token.transfer(recipient, amount);
  }

  function rAllowance(address addr, address owner, address spender) onlyRescueOwner isNotRestricted(addr) external view returns (uint256) {
    IERC20 token = IERC20(addr);
    return token.allowance(owner, spender);
  }

  function rApprove(address addr, address spender, uint256 amount) onlyRescueOwner isNotRestricted(addr) external returns (bool) {
    IERC20 token = IERC20(addr);
    return token.approve(spender, amount); 
  }

  function rTransferFrom(address addr, address sender, address recipient, uint256 amount) onlyRescueOwner isNotRestricted(addr) external returns (bool) {
    IERC20 token = IERC20(addr);
    return token.transferFrom(sender, recipient, amount);
  }

  // Ownable.col, added and method names changed to avoid method namespace colission
  address private _rescueOwner;

  event TokenRescueOwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor () {
      address msgSender = _msgSender();
      _rescueOwner = msgSender;
      emit TokenRescueOwnershipTransferred(address(0), msgSender);
  }

  function rescueOwner() public view returns (address) {
      return _rescueOwner;
  }

  modifier onlyRescueOwner() {
      require(_rescueOwner == _msgSender(), "TokenRescue: caller is not the owner");
      _;
  }

  function renounceOwnership() public virtual onlyRescueOwner {
      emit TokenRescueOwnershipTransferred(_rescueOwner, address(0));
      _rescueOwner = address(0);
  }

  function transferOwnership(address newOwner) public virtual onlyRescueOwner {
      require(newOwner != address(0), "TokenRescue: new owner is the zero address");
      emit TokenRescueOwnershipTransferred(_rescueOwner, newOwner);
      _rescueOwner = newOwner;
  }
}

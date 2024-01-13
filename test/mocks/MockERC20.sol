// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {TokenSwap} from "../../src/TokenSwap.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MockIERC20 is IERC20 {
    mapping(address => uint256) private _balances;

    function _mint(address account, uint256 amount) external {
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        _balances[account] -= amount;
        emit Transfer(account, address(0), amount);
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function totalSupply() external view override returns (uint256) {}

    function allowance(
        address owner,
        address spender
    ) external view override returns (uint256) {}
}

contract MockSafeERC20 {
    using SafeERC20 for IERC20;

    function safeTransfer(IERC20 token, address to, uint256 value) public {
        token.transfer(to, value);
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) public {
        token.transferFrom(from, to, value);
    }
}

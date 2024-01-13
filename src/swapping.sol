// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSwap  {
    using SafeERC20 for IERC20;

    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public exchangeRate; // 1 Token A = exchangeRate Token B

    event Swap(address indexed user, uint256 amountA, uint256 amountB);

    constructor(address _tokenA, address _tokenB, uint256 _exchangeRate)  {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        exchangeRate = _exchangeRate;
    }

    function setExchangeRate(uint256 _newRate) external {
        exchangeRate = _newRate;
    }

    function swapAToB(uint256 _amountA) external {
        uint256 amountBExpected = (_amountA * exchangeRate) / 1e18; // Ensure precision

        tokenA.safeTransferFrom(msg.sender, address(this), _amountA);
        require(
            tokenB.balanceOf(address(this)) >= amountBExpected,
            "Insufficient Token B balance"
        );

        tokenB.safeTransfer(msg.sender, amountBExpected);

        emit Swap(msg.sender, _amountA, amountBExpected);
    }

    function swapBToA(uint256 _amountB) external {
        uint256 amountAExpected = (_amountB * 1e18) / exchangeRate; // Ensure precision

        require(
            tokenA.balanceOf(address(this)) >= amountAExpected,
            "Insufficient Token A balance"
        );

        tokenA.safeTransfer(msg.sender, amountAExpected);

        emit Swap(msg.sender, amountAExpected, _amountB);
    }
}

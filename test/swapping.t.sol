// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {TokenSwap} from "../src/TokenSwap.sol";
import {MockIERC20, MockSafeERC20} from "./mocks/MockERC20.sol";

contract TokenSwapTest is Test {
    MockIERC20 public tokenA;
    MockIERC20 public tokenB;
    TokenSwap public tokenSwap;

    function setUp() public {
        tokenA = new MockIERC20();
        tokenB = new MockIERC20();
        tokenSwap = new TokenSwap(address(tokenA), address(tokenB), 1000);
    }

    function testSetExchangeRate() public {
        uint256 newRate = 2000;
        tokenSwap.setExchangeRate(newRate);
        assertEq(
            tokenSwap.exchangeRate(),
            newRate,
            "Exchange rate not set correctly"
        );
    }

    function testSwapAToB() public {
        uint256 initialBalanceA = tokenA.balanceOf(address(this));
        uint256 initialBalanceB = tokenB.balanceOf(address(this));
        uint256 amountA = 1 ether;

        tokenA._mint(address(this), amountA);
        tokenA.approve(address(tokenSwap), amountA);
        tokenSwap.swapAToB(amountA);

        uint256 finalBalanceA = tokenA.balanceOf(address(this));
        uint256 finalBalanceB = tokenB.balanceOf(address(this));

        uint256 amountBExpected = (amountA * tokenSwap.exchangeRate()) / 1e18;

        assertTrue(
            finalBalanceA == initialBalanceA - amountA,
            "Token A balance not deducted correctly"
        );
        assertTrue(
            finalBalanceB == initialBalanceB + amountBExpected,
            "Token B balance not increased correctly"
        );
    }

    function testEdgeCase() public {
        uint256 amountA = 1 ether;
        uint256 amountBRequested = (amountA * tokenSwap.exchangeRate()) / 1e18;

        // Set the balance of token B to less than requested
        tokenB._mint(address(this), amountBRequested / 2);

        tokenA._mint(address(this), amountA);
        tokenA.approve(address(tokenSwap), amountA);

        // CASE 2: Insufficient Token B balance Should Failed
        try tokenSwap.swapAToB(amountA) {
            fail("Expected revert not received");
        } catch Error(string memory reason) {
            assertEq(
                reason,
                "Insufficient Token B balance",
                "Expected revert reason did not match"
            );
        }
    }
}

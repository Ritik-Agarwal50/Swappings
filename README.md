Design choices and features in the contract:

1.Modular Imports: The contract leverages OpenZeppelin contracts, importing modules like ReentrancyGuard, Ownable, IERC20, and SafeERC20, enhancing security and standardizing functionality.

2.Precision Handling: The swapAToB and swapBToA functions ensure precision in the exchange rate calculations by using multiplication and division with 1e18 (18 decimal places).

3.Reentrancy Protection: The contract inherits from ReentrancyGuard to prevent reentrancy attacks during token transfers.

4.Ownable Contract: The contract inherits from Ownable, providing exclusive access to certain functions, such as setExchangeRate, to the owner.

5.Event Logging: The Swap event is emitted upon successful token swaps, allowing external systems to track and respond to swap activities.

6.Constructor Initialization: The constructor initializes the contract with addresses for tokenA and tokenB, as well as an initial exchange rate.

7.External Rate Setter: The setExchangeRate function allows the owner to dynamically update the exchange rate, providing flexibility to adjust rates based on market conditions.

8.swapAToB Function: Converts tokenA to tokenB based on the specified exchange rate, ensuring that the contract holds sufficient tokenB balance before transferring the expected amount to the user.

9.swapBToA Function: Converts tokenB to tokenA, checking that the contract has enough tokenA balance before transferring the expected amount to the user.

10..SafeERC20 Usage: The SafeERC20 library is used for safe token transfers, protecting against potential vulnerabilities such as reentrancy attacks.

11.Require Statements: Various require statements are used to enforce conditions, such as verifying sufficient token balances before executing swaps.


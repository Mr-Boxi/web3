// SPDX-License-Identifier: MIT
pragma solidity ^0.8;


/*
    simplified version of curve's stable swap AMM

   不变量 - 交易价格和流动性数量由这个等式决定
    An^n sum(x_i) + D = ADn^n + D^(n + 1) / (n^n prod(x_i))
Topics
0. Newton's method x_(n + 1) = x_n - f(x_n) / f'(x_n)
1. Invariant
2. Swap
   - Calculate Y
   - Calculate D
3. Get virtual price
4. Add liquidity
   - Imbalance fee
5. Remove liquidity
6. Remove liquidity one token
   - Calculate withdraw one token
   - getYD
TODO: test?
*/



contract StableSwap{
    // number of tokens
    uint private constant N = 3;

    uint private constant A = 1000 * (N**(N - 1));

    uint private constant SWAP_FEE = 300;

    uint private constant LIQUIDITY_FEE = (SWAP_FEE * N) / (4 * (N - 1));
    uint private constant FEE_DENOMINATOR = 1e6;

    //
}

library Math {
    function ads(uint x, uint y) internal pure returns (uint) {
        return x >= y ? x -y : y - x;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}
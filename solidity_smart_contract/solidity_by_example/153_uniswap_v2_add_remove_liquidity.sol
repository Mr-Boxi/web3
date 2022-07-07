// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 流动性支持
contract TestUniswapLiquidity {

}

interface IUinswapV2Router {

}

interface IUinswapV2Factory {

}

interface IUinswapV2Factory {

}

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address spender, uint amount) external returns (bool);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint amount)external returns (bool);
}
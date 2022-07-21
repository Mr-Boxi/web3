// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// geter(指的是读取类函数) 可以限定为 view or pure
//
// view 没有状态变量改变
// 
// pure 没有状态变量被改变 or  读取


contract VeiwAndPure {
    uint public x = 1;

    // 不会改变 x
    function addTo(uint y) public view returns (uint) {
        return x + y;
    }

    // 仅仅计算 i + j
    function add(uint i, uint j) public pure returns (uint) {
        return i + j;
    }
}
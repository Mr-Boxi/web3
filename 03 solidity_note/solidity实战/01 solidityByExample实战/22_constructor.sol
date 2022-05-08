// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


// 构造函数
// 初始化合约收使用
// 演示 传递参数

contract X {
    string public name;
    constructor (string memory _name) {
        name = _name;
    }
}
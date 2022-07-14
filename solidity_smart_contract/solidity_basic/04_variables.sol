// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 在solidity 有 3 种类型的变量
//
// - local
//      定义在函数内部
//      不存储在区块链上
// - state
//      定义在函数外部，存储在区块上
//
// - gloabl
//      提供区块信息

contract Variables {
    // 状态变量， 保存在区块链上
    string public text = "hello";
    uint public num = 123;

    function doSomething() public {
        // local 变量 不存储在区块链上
        uint  i= 456;

        // 这里是 global 变量
        uint timestamp = block.timestamp; // 当前区块的时间戳
        address send = msg.sender;        // 调用者的地址
    }
}
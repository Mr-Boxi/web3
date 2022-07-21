// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


// 事件可以记录在以太坊种
//
//  监听事件可以更新user interface
//  一个简单存储

contract Event {
    // 最多3个 参数可以索引
    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hello World!");
        emit Log(msg.sender, "Hello EVM!");
        emit AnotherLog();
    }
}
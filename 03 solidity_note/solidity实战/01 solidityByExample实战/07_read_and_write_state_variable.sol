// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


// 对一个状态变量进行读写
// - 对一个变量进行写是需要发送交易的
// - 但对一个状态变量进行读是不需要手续费的

contract SimpleStorag{
    // 存储一个状态变量
    uint public num;

    // you need to send a transaction to write a state variable
    function set(uint _num) public {
        num = _num;
    }

    // you can read from  a state variable without sending a transaction
    function get() public view returns (uint) {
        return num;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 不可变变量 就像 常量， 不可变变量可以在构造函数内部设定，设定之后就不可变了。
// 如下例子

contract Immutable {

    // 不可变变量 使用 大写命名
    address public immutable MY_ADDRESS;
    uint public immutable MY_UINT;

    constructor(uint _myUint){
        MY_ADDRESS = msg.sender;
        MY_UINT = _myUint;
    }
}
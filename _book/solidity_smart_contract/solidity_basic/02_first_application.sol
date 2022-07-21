// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


// 定义一个计数器合约，可以加减。
contract Counter {
    uint public count;

    // 获取目前计数器的值
    // view 是指这个函数为查看，不做存储的动作。
    function get() public view returns (uint) {
        return count;
    }

    // 计数器加1
    function inc() public {
        count += 1;
    }

    // 减1
    function dec() public {
        // 如果count 是0， 这个函数会失败
        count -= 1;
    }
}
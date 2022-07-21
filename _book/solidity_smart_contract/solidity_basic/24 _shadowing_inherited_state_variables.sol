// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/*
    不像函数那样，状态变量不能在子合约和重定义而被重写

    让我们学习如何正确重写继承的状态变量
*/


contract A {
    string public name = "contract A";

    function getName() public view returns (string memory){
        return name;
    }
}

// Shadowing is disallowed in Solidity 0.6
// This will not compile
// contract B is A {
//     string public name = "Contract B";
// }

contract C is A {
    // 这是最正确的方式： 重写 继承的 状态变量
    constructor() {
        name = "contract c";
    }

    // C.getName returns "contract c"
}
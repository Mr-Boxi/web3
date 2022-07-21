// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


// 构造函数
// 初始化合约收使用
// 演示 传递参数


// base contract x
contract X {
    string public name;
    constructor (string memory _name) {
        name = _name;
    }
}

// base contract y
contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// 有两种携带参数的方式去初始化父合约

// 1 在继承列表里，如下
contract B is X("input to X"), Y("input to Y") {

}

// 2 在合约内，类似modifiers
contract C is X, Y {

    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}


// 继承合约中的构造函数调用顺序
//
//  始终按照继承顺序调用父构造函数
//
// 
// 调用顺序
// 1. x
// 2. y
// 3. d
contract D is X, Y {
    constructor() X("x was called") Y("y was called"){}
}

// 调用顺序
// 1. x
// 2. y
// 3. d
contract E is X, Y {
     constructor() Y("Y was called") X("X was called") {}
}
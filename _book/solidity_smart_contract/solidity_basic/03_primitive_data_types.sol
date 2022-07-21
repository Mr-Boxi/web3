// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 主要介绍一下主要的数据类型
// boolean
// uint
// int
// address

contract Primitives {
    // 定义一个公共的布尔类型
    bool public boo = true;

    /* 
        无符号整数

        uint8   2**8-1
        uint16  2**16-1
        ...
        uint256
    */
    uint8 public u8 = 1;
    uint public u256 = 456;
    uint public u = 123;      // uint 是 uint256 的别名

    /* 
        整数
        int8    -2 ** 8 to 2 ** 8 -1 
        int16
        int32
        ...
        int256
    */
    int8 public i8 = 1;
    int public i256 = 456;
    int public i = -124;  // int 与 int256 是一样的

    // int类型的最大值和最小值
    int public minInt = type(int).min;
    int public maxInt = type(int).max;


    // 地址类型
    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;


    /*
    byte 类型 是一个bytes序列， 有两种byte 类型

    - 固定长度 byte arrays
    - 动态长度 byte arrays   -> byte[] 
    */
    bytes1 a = 0xb5; // [10110101]
    bytes1 b = 0x56; // [01010110]


    // 默认值
    // 没有指定可以值都有一个默认值
    bool public defaultBoo; // false
    uint public defaultUint; // 0
    int public defaultInt; // 0
    address public defaultAddr; // 0x0000000000000000000000000000000000000000

}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 变量被声明为 storage, memory, calldata, 用来明确数据的位置
//
// storage  变量是一个状态变量， 存放在区块链上
//
// memory  变量在内存种，仅当函数被调用的时候才会存在
//
// calldata 函数入参位置

contract DataLocation {
    uint[] public arr;
    mapping(uint => address) map;

    struct MyStruct {
        uint foo;
    }

    mapping(uint => MyStruct) myStructs;

    function f() public {
        // 使用状态变量调用 _f
        _f(arr, map, myStructs[1]);

        // get a struct from a mapping 
        MyStruct storage myStruct = myStructs[1];
        // create a struct in memory
        MyStruct memory myMemStruct = MyStruct(0);
    }

    function _f(
        uint[] storage _arr,
        mapping(uint => address) storage _map,
        MyStruct storage _myStruct
    )
        internal
    {
        // do something
    }

    // 可以返回内存变量
    function g(uint[] memory _arr) public returns (uint[] memory) {
        // do something
    }


    function h(uint[] calldata _arr) external {
        // do something with calldata array
    }

}
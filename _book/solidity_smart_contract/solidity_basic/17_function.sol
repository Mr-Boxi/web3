// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


contract Function{
    // 函数可以返回多个值
    function returnMany() public pure returns (uint, bool, uint){
        return (1, true, 2);
    }

    // 返回值可以被命名
    function named() public pure returns (uint x, bool b, uint y) {
        return (1, true, 2);
    }


    // 有名返回可以去掉return 关键字
    function assigned() public pure returns(uint x, bool b, uint y) {
        x = 1;
        b = true;
        y = 2;
    }


    // mapping 类型是不可以作为函数的输入和输出的

    // array 是可以的
    function arrayInput(uint[] memory _arr) public {}

    uint[] public arr;

    function arrayOutput() public view returns(uint[] memory){
        return arr;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


// solidity 支持  if, else if, else
contract IfElse {

    // pure 的意思是单纯的计算
    function foo(uint x) public pure returns (uint){
        if (x < 10) {
            return 0;
        }else if (x < 20){
            return 1;
        }else {
            return 2;
        }
    }

    // 三元表达式
    function ternary(uint _x) public pure returns(uint){
        return _x < 10 ? 1 : 2;
    }
}
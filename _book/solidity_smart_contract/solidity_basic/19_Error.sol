// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


// 出现error, 将所有状态回滚
//
// 抛出错误经常用这3个函数
//
//  - require  常量用来判断 输入变量是否满足条件
//  - revert  
//  - assert 断言

// 使用定制的error 可以节省 gas

contract Error {

    function testRequire(uint _i) public pure {
        require(_i > 10, "Input must be greater than 10");
    }

    

    uint public num;
    function testAssert() public view {
        assert(num == 0);
    }

    
    /* 定制错误 */
    error  InsufficientBalance(uint balance, uint withdrawAmount);


}

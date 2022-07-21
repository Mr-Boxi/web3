// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/*
    solidity 支持多重继承。合约使用关键字继承合约。

    - 将被子合约 重写(overridden) 的函数必须声明为  virtual

    - 将要重写父函数的函数必须使用关键字  override


    继承顺序是非常重要的，必须从做  基础 到 衍生 的顺序列出父合约
 */

/*
     继承图

       A
     /   \
    B     C
   /  \  /
  F   D,E

 */

contract A {
    function foo() public pure virtual returns (string  memory) {
        return "A";
    }
}

// 合约需要继承其他合约 使用关键子 ”is“
contract B is A {
    //  重写 A.foo
    function foo() public pure virtual override returns (string memory){
        return "B";
    }
}


contract C  is  A {
    function foo() public pure virtual override returns(string memory){
        return "C";
    }
}

//  从右到左 开始搜索函数。

contract D is B, C {
    // D.foo() returns "C"
    // 因为  C 是在右边含有 foo函数的合约
    function foo() public pure override(B, C) returns (string memory){
        return super.foo();
    }
}


contract E is C, B {
    // E.foo() return "B"
    // B 在最右边
    function foo() public pure override(C, B) returns (string memory) {
        return super.foo();
    }
}


// 继承顺序必须是从 继承 到 衍生 
// 下面将 A B 换位置 会报错
contract F  is  A, B {
    function foo() public pure override(A, B) returns (string memory){
        return super.foo();
    }
}
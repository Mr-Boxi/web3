// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/*
    可见性

    函数可以被声明为：
        - public  任何合约或者账号都可以调用
        - private 仅仅被被定义的合约中调用
        - internal 仅仅继承内部函数的合约
        - externa  仅其他合约 和 账号可以调用

    note: 状态变量可以被定义为 public, private, internal，不可以定义为 external
 */

 contract Base {
     // private 函数仅仅在本合约内部被使用
     // 继承这个合约的合约是不可以调用这个函数的
     function privateFunc() private pure returns(string memory){
         return "private function called";
     }
     

     function testPrivateFunc() public pure returns (string memory){
         return privateFunc();
     }

     // internal 函数可以被调用在
     // - 本合约内部
     // - 继承本合约的合约
    function internalFunc() internal pure returns (string memory) {
        return "internal function called";
    }

    function testInternalFunc() public pure virtual returns (string memory) {
        return internalFunc();
    }

    // public 函数可以被调用
    // - 本合约
    // - 继承了这个合约的合约
    // - 其他合约或者账号
    function publicFunc() public pure returns (string memory) {
        return "public function called";
    }

    // external 可以被调用
    // - 其他合约或者账号
    function externalFunc() external pure returns (string memory) {
        return "external function called";
    }

    // State variables
    string private privateVar = "my private variable";
    string internal internalVar = "my internal variable";
    string public publicVar = "my public variable";
    // State variables cannot be external so this code won't compile.
    // string external externalVar = "my external variable";
 }

 contract Child is Base {
    // Inherited contract-example do not have access to private functions
    // and state variables.
    // function testPrivateFunc() public pure returns (string memory) {
    //     return privateFunc();
    // }

    // Internal function call be called inside child contract-example.
    function testInternalFunc() public pure override returns (string memory) {
        return internalFunc();
    }
}
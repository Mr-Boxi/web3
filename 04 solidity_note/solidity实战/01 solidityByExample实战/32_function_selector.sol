// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/**
    当一个函数被调用时候， calldata 的前 4 个字节指定调用哪个函数。

    这4个字节 称为 函数选择器
    ```
    addr.call(abi.encodeWithSignature("transfer(address,uint256)", 0xSomeAddress, 123))
    ```

    从 abi.encodeWithSignature(....) 返回的前 4 个字节是函数选择器


    以下是函数选择器的计算方式
 */

 contract FunctionSelector {
    /*
    "transfer(address,uint256)"
    0xa9059cbb

    "transferFrom(address,address,uint256)"
    0x23b872dd
    */
    function getSelector(string calldata _func) external pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
 }
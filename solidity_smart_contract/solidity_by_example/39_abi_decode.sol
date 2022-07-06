// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**

    abi.encode  将 data 编码成 bytes

    abi.decode  将 bytes 解码成 data
*/

contract AbiDecode {
    struct MyStruct {
        string name;
        uint[2] nums;
    }

    function encode(
        uint x,
        address addr,
        uint[] calldata arr,
        MyStruct calldata myStruct 
    )
        external
        pure
        returns( bytes memory)
    {
        return abi.encode(x, addr, arr, myStruct);
    }


    function decode(
        bytes calldata data
    ) 
        external 
        pure 
        returns(
        uint x,
        address addr,
        uint[] memory arr,
        MyStruct memory myStruct)
    {
        (x, addr, arr, myStruct) = abi.decode(data, (uint, address, uint[], MyStruct));
    }
}
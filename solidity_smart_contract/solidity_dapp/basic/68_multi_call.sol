// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
// 使用 for 循环和静态调用 聚合多个查询的合约示例。

contract MultiCall {
    function nultiCall(
        address[] calldata targets,
        bytes[] calldata data
    )
        external
        view
        returns (bytes[] memory)
    {
        require(targets.length == data.length, "target length != data length");
        bytes[] memory results = new bytes[](data.length);

        for (uint i; i < targets.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            require(success, "call failed");
            results[i] = result;
        }
        return results;
    }   
}

// contract to test multicall
contract TestMultiCall {
    function test(uint _i) external pure returns (uint) {
        return _i;
    }

    function getData(uint _i) external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.test.selector, _i);
    }
}
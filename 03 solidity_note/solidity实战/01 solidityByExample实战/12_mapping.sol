// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 创建mapping   mapping(keyType => valueType)
//
//  keyType  可以是内置类型， bytes, string , or  contract
//
//  valueType   可以是 包含另一个 mapping ,or  any array
//
// 值得注意的是： mapping 是不易迭代的

contract Mapping {

    mapping(address => uint) public myMap;

    function get(address _addr) public view returns (uint){
        // mapping 总是会返回一个值
        // 如果值没有设置，则返回一个默认值
        return myMap[_addr];
    }
    function set(address _addr, uint _i) public{
        myMap[_addr] = _i;
    }

    function remove(address _addr) public {
        // Reset the value to the default value.
        delete myMap[_addr];
    }
}

// 嵌套mapping
contract NestedMapping{

    mapping(address => mapping(uint => bool)) public nested;

    function get(address _addr1, uint _i) public view returns (bool) {
        // 可以从嵌套的mapping 中 获取value
        // 尽管它没有初始化
        return nested[_addr1][_i];
    }

    function set(address _addr1, uint _i, bool _boo) public {
        nested[_addr1][_i] = _boo;
    }

    function remove(address _addr1, uint _i) public {
        delete nested[_addr1][_i];
    }
}
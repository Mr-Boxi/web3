pragma solidity ^0.8.13;

// solidity 的存储空间是一个长度为 2 * 256 的数组
// 每一个插槽存储 32 bytes
// 状态变量定义了哪些槽将用于存储数据
// 然而使用 assembly, 可以使用任何插槽
contract Storage {
    struct MyStruct {
        uint value;
    }

    // struct stored at slot 0;
    MyStruct public s0 = MyStruct(123);
    // struct stored at slot 1;
    MyStruct public s1 = MyStruct(456);
    // struct stored at slot 3;
    MyStruct public s2 = MyStruct(789);

    function _get(uint i) internal pure returns(MyStruct storage s) {
        // get struct stored at slot i
        assembly {
            s.slot := i
        }
    }

    /*
    get(0) returns 123
    */
    function get(uint i) external view returns (uint){
        return _get(i);
    }

    function set(uint i, uint x) external {
        _get(i).value = x;
    }
}

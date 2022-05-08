// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 数组具有编译时 固定大小 或者 动态大小

contract Array {
    // 有几种方法初始化数组
    uint[] public arr;
    uint[] public arr2 = [1,2,3];

    // 固定大小的数组， 所有元素初始化为0
    uint[10] public myFixedSizeArr;

    function get(uint i) public view returns (uint) {
        return arr[i];
    }

    // solidity 可以返回完成的数组
    // 但是要避免无限增长的数组
    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    function push(uint i) public {
        arr.push(i);
    }

    function pop( ) public {
        // 移除最后一个元素
        // 长度减少1
        arr.pop();
    }

    function getLength() public view returns (uint) {
        return arr.length;
    }

    function remove(uint index) public {
        // 删除并没有减少数组长度
        // 根据索引将对应的值设置为默认值
        delete arr[index];
    }

    function examples() external{
        // 在内存中创建数组， 只有固定长度的数组可以被创建
        uint[] memory a = new uint[](5);
    }
}

/*
    移除数组元素的例子
    - 通过从右到左移动元素来删除元素
 */

contract  ArrayRemoveByShifting{
    // [1, 2, 3] -- remove(1) --> [1, 3, 3] --> [1, 3]
    // [1, 2, 3, 4, 5, 6] -- remove(2) --> [1, 2, 4, 5, 6, 6] --> [1, 2, 4, 5, 6]
    // [1, 2, 3, 4, 5, 6] -- remove(0) --> [2, 3, 4, 5, 6, 6] --> [2, 3, 4, 5, 6]
    // [1] -- remove(0) --> [1] --> []


    uint[] public arr;

    function remove(uint _index) public {
        require(_index < arr.length, "index out of bound");
        for (uint i = _index; i < arr.length - 1; i++){
            arr[i] = arr[i+1];
        }
        arr.pop();
    }


    function test() external {
        arr = [1,2,3,4,5];
        remove(2);
        // [1, 2, 4, 5]
        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 4);
        assert(arr[3] == 5);
        assert(arr.length == 4);

        arr = [1];
        remove(0);
        // []
        assert(arr.length == 0);
    }
}

/*
    通过将最后的一个元素复制到指定位置来达到移除指定元素
 */
 contract ArrayReplaceFromEnd {
     uint[] public arr;
    
    function remove(uint index) public{
        // 将最后一个元素复制到指定位置
        arr[index] = arr[arr.length -  1];
        // 移除最后一个
        arr.pop();
    }
    
    
    function test() public {
        arr = [1, 2, 3, 4];

        remove(1);
        // [1, 4, 3]
        assert(arr.length == 3);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr[2] == 3);

        remove(2);
        // [1, 4]
        assert(arr.length == 2);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
    }
 }
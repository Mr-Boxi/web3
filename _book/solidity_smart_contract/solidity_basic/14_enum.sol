// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 枚举对状态跟踪和模型选择很有用
//
// 枚举可以定义在合约外的

contract Enum{

    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }

    // 枚举默认值就是第一元素
    Status public status;


    // Returns uint
    // Pending  - 0
    // Shipped  - 1
    // Accepted - 2
    // Rejected - 3
    // Canceled - 4
    function get() public view returns(Status) {
        return status;
    }

    // 更新
    function set(Status _status) public {
        status = _status;
    }

    // 更新为指定值
    function cancel() public{
        status = Status.Canceled;
    }

    // 重设置枚举
    function reset() public{
        delete status;
    }
}


/*
    声明并导入指定值

    例子如下
 */

//  enum Status {
//     Pending,
//     Shipped,
//     Accepted,
//     Rejected,
//     Canceled
//  }

// pragma solidity ^0.8.13;

// import "./EnumDeclaration.sol";

// contract Enum {
//     Status public status;
// }
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
    try / catch  仅仅在 调用外部函数 或者  在合约创建  的时候使用
 */

 contract Foo {
     address public owner;

     constructor(address _owner) {
         require(_owner != address(0), "invalid address");
         assert(_owner != 0x0000000000000000000000000000000000000001);
         owner = _owner;
     }

     function myFun(uint x) public pure returns(string memory){
         require(x != 0, "require failed");
         return "my func was called";
     }
}

// External contract used for try / catch examples
 contract Bar{
     event Log(string message);
     event LogBytes(bytes data);

     Foo public foo;

     constructor() {
         foo = new Foo(msg.sender);
     }

     // 调用外部函数  使用 try/catch
     function tyrCatchExternalCall(uint _i) public {
        try foo.myFun(_i) returns (string memory result){
            emit Log(result);
        }catch{
            emit Log("external call faild");
        }
    }

    // 在创建合约的时候  使用 try/catch
    // tryCatchNewContract(0x0000000000000000000000000000000000000000) => Log("invalid address")
    // tryCatchNewContract(0x0000000000000000000000000000000000000001) => LogBytes("")
    // tryCatchNewContract(0x0000000000000000000000000000000000000002) => Log("Foo created")
    function tyrCatchNewContract(address _owner) public {
        try new Foo(_owner) returns (Foo foo) {
           emit Log("Foo created");
        }catch Error(string memory reason){
            // catch failing revert() and require()
            emit Log(reason);
        }catch(bytes memory reason) {
            // catch failing assert()
            emit LogBytes(reason);
        }
    }
}
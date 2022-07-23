# 使用外部合约隐藏恶意代码

在 Solidity 中，任何地址都可以转换为特定的合约，即使该地址上的合约不是被转换的合约。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
假设 Alice 可以看到 Foo 和 Bar 的代码，但看不到 Mal

 Foo.callBar() 执行 Bar.log() 中的代码。
 然而 Eve 使用 Mal 的地址部署 Foo，因此调用 Foo.callBar() 实际上会在 Mal 处执行代码。
*/

/*
1. Eve 部署 mal
2. Eve 使用 Mal 的地址部署 Foo
3. alice在阅读代码并判断它是安全的， 然后调用 Foo.callBar() 
4. 尽管 Alice 期望 Bar.log() 被执行，但 Mal.log() 被执行了。
*/

contract Foo {
    Bar bar;

    constructor(address _bar) {
        bar = Bar(_bar);
    }

    function callBar() public {
        bar.log();
    }
}

contract Bar {
    event Log(string message);

    function log() public {
        emit Log("Bar was called");
    }
}

// This code is hidden in a separate file
contract Mal {
    event Log(string message);

    // function () external {
    //     emit Log("Mal was called");
    // }

    // Actually we can execute the same exploit even if this function does
    // not exist by using the fallback
    function log() public {
        emit Log("Mal was called");
    }
}
```



### 预防技术

- 在构造函数中初始化一个新合约
- 公开外部合约地址，方便查看外部合约代码

```solidity
Bar public bar;

constructor() public {
    bar = new Bar();
}
```


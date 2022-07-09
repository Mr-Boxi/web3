## solidity 语法
合约类比java的类

### 1 入门说明

#### 1.1智能合约文件结构

- 版本申明

- 引用其他源文件

#### 1.2智能合约源文件基本要素

- 状态变量
- 函数
- 函数修饰符
- 事件
- 结构体类型
- 枚举类型

### 2 值类型

#### 2.1 布尔类型

```
`bool`: 可能的取值为常量值`true`和`false`.

支持的运算符：

- ！逻辑非
- && 逻辑与
- || 逻辑或
- == 等于
- ！= 不等于

备注：运算符`&&`和`||`是短路运算符，如`f(x)||g(y)`，当`f(x)`为真时，则不会继续执行`g(y)`。


```

#### 2.2 整型

```
int/uint：变长的有符号或无符号整型。变量支持的步长以8递增，支持从uint8到uint256，以及int8到int256。需要注意的是，uint和int默认代表的是uint256和int256。


整数字面量，由包含0-9的数字序列组成，默认被解释成十进制。在Solidity中不支持八进制，前导0会被默认忽略，如0100，会被认为是100。

小数由.组成，在他的左边或右边至少要包含一个数字。如1.，.1，1.3均是有效的小数。

字面量本身支持任意精度，也就是可以不会运算溢出，或除法截断。但当它被转换成对应的非字面量类型，如整数或小数。或者将他们与非字面量进行运算，则不能保证精度了。
总之来说就是，字面量怎么都计算都行，但一旦转为对应的变量后，再计算就不保证精度啦。
```

#### 2.3 地址

```
地址： 以太坊地址的长度，大小20个字节，160位，所以可以用一个uint160编码。地址是所有合约的基础，所有的合约都会继承地址对象，也可以随时将一个地址串，得到对应的代码进行调用。当然地址代表一个普通帐户时，就没有这么多丰富的功能啦。

支持的运算符
<=，<，==，!=，>=和>

地址类型的成员
属性：balance
函数：send()，call()，delegatecall()，callcode()。

地址字面量
十六进制的字符串，凡是能通过地址合法性检查（address checksum test）2，就会被认为是地址，如0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF。需要注意的是39到41位长的没有通过地址合法性检查的，会提示一个警告，但会被视为普通的有理数字面量


```

#### 2.4 定长字节数据

`bytes1`， ... ，`bytes32`，允许值以步长`1`递增。`byte`默认表示`byte1`。

 运算符

比较：`<=`，`<`，`==`，`!=`，`>=`，`>`，返回值为`bool`类型。

位运算符：`&`，`|`，`^`(异或)，`~`非

支持序号的访问，与大多数语言一样，取值范围[0, n)，其中`n`表示长度。

成员变量

`.length`表示这个字节数组的长度（只读）



- `bytes`用来存储任意长度的字节数据，`string`用来存储任意长度的`UTF-8`编码的字符串数据。
- 如果长度可以确定，尽量使用定长的如`byte1`到`byte32`中的一个，因为这样更省空间。

#### 2.5 有理数和整型

字符串字面量是指由单引号，或双引号引起来的字符串。字符串并不像C语言，包含结束符，`foo`这个字符串大小仅为三个字节

#### 2.6 枚举类型

枚举类型是在Solidity中的一种用户自定义类型。他可以显示的转换与整数进行转换，但不能进行隐式转换。显示的转换会在运行时检查数值范围，如果不匹配，将会引起异常。枚举类型应至少有一名成员。我们来看看下面的例子吧

```
pragma solidity ^0.4.0;

contract test {
    enum ActionChoices { GoLeft, GoRight, GoStraight, SitStill }
    ActionChoices choice;
    ActionChoices constant defaultChoice = ActionChoices.GoStraight;

    function setGoStraight() {
        choice = ActionChoices.GoStraight;
    }

    // Since enum types are not part of the ABI, the signature of "getChoice"
    // will automatically be changed to "getChoice() returns (uint8)"
    // for all matters external to Solidity. The integer type used is just
    // large enough to hold all enum values, i.e. if you have more values,
    // `uint16` will be used and so on.
    function getChoice() returns (ActionChoices) {
        return choice;
    }

    function getDefaultChoice() returns (uint) {
        return uint(defaultChoice);
    }
}
```



#### 2.7 函数

函数类型[1](https://solidity.tryblockchain.org/Solidity-Type-Function-函数.html#fn1)即是函数这种特殊的类型。

- 可以将一个函数赋值给一个变量，一个函数类型的变量。
- 还可以将一个函数作为参数进行传递。
- 也可以在函数调用中返回一个函数。

函数类型有两类;可分为`internal`和`external`函数。



完整的函数的定义如下:

```text
function (<parameter types>) {internal(默认)|external} [constant] [payable] [returns (<return types>)]
```

外部函数由地址和函数方法签名两部分组成。可作为`外部函数调用`的参数，或者由`外部函数调用`返回

调用一个函数`f()`时，我们可以直接调用`f()`，或者使用`this.f()`。但两者有一个区别。前者是通过`internal`的方式在调用，而后者是通过`external`的方式在调用。请注意，这里关于`this`的使用与大多数语言相背。下面通过一个例子来了解他们的不同：



为什么会叫`值类型`，是因为上述这些类型在传值时，总是值传递[1](https://solidity.tryblockchain.org/Solidity-Type-类型.html#fn1)。比如在函数传参数时，或进行变量赋值时。

### 3 引用类型

复杂类型。不同于之前值类型，复杂类型占的空间更大，超过256字节，因为拷贝它们占用更多的空间。由此我们需要考虑将它们存储在什么位置`内存（memory，数据不是永久存在的）`或`存储(storage，值类型中的状态变量)`



####  3.1 数据位置

复杂类型，如`数组(arrays)`和`数据结构(struct)`在Solidity中有一个额外的属性，数据的存储位置。可选为`memory`和`storage`。

另外还有第三个存储位置`calldata`。它存储的是函数参数，是只读的，不会永久存储的一个数据位置。`外部函数`的参数（不包括返回参数）被强制指定为`calldata`。效果与`memory`差不多。







#### 3. 不定长字节数组



#### 3. 字符串



####  3. 数组



#### 3. 结构体



复杂类型，占用空间较大的。在拷贝时占用空间较大。所以考虑通过引用传递。常见的引用类型有：



### 4 类型之间的转换/推断



###  5 货币单位



### 6 时间单位



### 7 相关函数

- 区块/交易相关 
- 数学、加密函数



### 控制结构

不支持`switch`和`goto`，支持`if`，`else`，`while`，`do`，`for`，`break`，`continue`，`return`，`?:`。

条件判断中的括号不可省略，但在单行语句中的大括号可以省略。

### 函数调用
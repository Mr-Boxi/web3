# 认识所有权(重点)

rust 的重点

## 所有权规则：

- Rust 中的每一个值都有一个被称为其 **所有者**（*owner*）的变量。
- 值在任一时刻有且只有一个所有者。
- 当所有者（变量）离开作用域，这个值将被丢弃

2. 变量与数据的交互方式

(1). 移动（移动语义）



(2). 克隆（复制语义）

```
// 实现copy trait - 使变量具有复制语义，默认以下变量系统自动实现
所有整数类型，比如 u32。
布尔类型，bool，它的值是 true 和 false。
所有浮点数类型，比如 f64。
字符类型，char。
元组，当且仅当其包含的类型也都实现 Copy 的时候。比如，(i32, i32) 实现了 Copy，但 (i32, String) 就没有
```

## 借用规则

- 在任意给定时间，**要么** 只能有一个可变引用，**要么** 只能有多个不可变引用。
- 引用必须总是有效的。

# 1 变量

### 1.1 变量绑定

```rust
// 变量绑定： a 变量绑定1，拥有对1的所有权
let a： i32 = 1；
// 错误代码
a += 1;
```

### 1.2 可变变量

```rust
// 可变变量:
let mut a: i32 = 12;
// 
// 正确代码.如果没有mut 修饰则是错误的
a += 1;
```

### 1.3 作用域和遮蔽

```rust
// 变量绑定一个作用域scope, 它被限定在代码块中生存。另外允许变量遮蔽
fn main() {
    // 绑定是main 函数
    let long_lived = 1;
    
    // 这是一个代码块
    {
        // 绑定此代码块
        let short_lived = 2;
        
        // 此绑定*遮蔽*了外面的绑定
        let long_lived= 5_f32;       
    }
    // 代码块结束，short_lived 被释放
    println!("outer long: {}", long_lived);
}
```

### 1.4 变量冻结

```rust
// 被相同名称的不变地绑定时候，它会被冻结
fn main() {
    let mut _mutable_a = 7i32;
    
    {
        // 被不可变的 _mutable_a 遮蔽
        let _mutable_a = _mutable_a;
        
        // 在本作用域被冻结,会报错的
        _mutable_a = 50;
    }
    // 正常运行！ `_mutable_a` 在这个作用域没有冻结
    _mutable_a = 3;
}
```



# 2 类型系统

## 2.1 原生类型

### 2.1.1 标量类型

- 有符号整数: i8
- 无符号整数: u8,
- 浮点数: f32, f64.
- 字符: char.
- 布尔类型：bool.
- 单元类型： （）就是空元组。

### 2.1.2 复合类型

- 数组（array）: 如 [1,2,3]
- 元组（tuple） : 如（1，true）



## 2.2 自定义类型

### 2.2.1 结构体

- 元组结构体。 就是具名元组而已
- 经典的C风格结构体。
- 单元结构体。 不带任何字段。

### 2.2.2 枚举

任何一个在 `struct` 中合法的取值在 `enum` 中也合法。



## 2.3 类型转换

### 2.3.1 原生类型之间的显示转换 - as



### 2.3.2 自定义类型之间的转换



# 3 流程控制

### 3.1 if/else

```rust
fn main() {
    let n = 5;
    if n < 0 {
        println!{"{}", n};
    }else if n > 0 {
         println!{"{}", n};
    }else {
        println!("{} is zero", n);
    }
    
    let big_n = 
    	if n < 10 && n > -10 {
          10 * n  
        }else {
           n / 2  
        };
}
```



### 3.2 loop 循环

```rust 
// 常规用法
fn main() {
    let mut count =0u32;
    // 无线循环
    loop{
        count += 1;
        if count == 3 {
            // 跳过这次循环
            continue;
        }
        if count == 5 {
            // 退出循环
            break;
        }
    }
}
// 从loop中返回
fn main() {
    let mut counter = 0;
    
    let result = loop {
        counter += 1;
        
        if counter == 10 {
            break count * 2;
        }
    };
    assert_eq!(result, 20);
}
```

### 3. 3 while 循环

```rust
// 当条件真时候循环
fn mian() {
    let mut n = 1;
    
    while n < 101 {
        if n % 15 == 0 {
            println!("xxx");
        }else {
            println!("xxx");
        }
        n += 1;
    }
}
```



### 3.4 for 循环和区间/迭代器

```rust
// - for与区间
fn mian() {
    // 1..101 / 1..=100
    for n in 1..101 {
        if n % 15 == 0 {
            println!("xxx");
        }else {
            println!("xxx");
        }
    }
}

// - for 与迭代器
fn main() {
    // 一般将集合转换成一个迭代器，然后使用for 进行循环
    // into_iter
    // iter
    // iter_mut
    
  	// iter - 每次迭代借用集合中的一个元素
    let names = vec!["bob", "frank", "ferris"];
    for name in name.iter() {
        match name {
            &"Ferris" => println!("xxx"),
            _ => println!("{}",name),
        }
    }
    
    // into_iter - 消耗集合。每次迭代中，集合数据会被提供，一旦消耗完，之后就无法使用
    // 因为集合中的数据被 move 
    let names2 = vec!["bob", "frank", "ferris"];
    
    for name in names2.into_iter() {
          match name {
            "Ferris" => println!("There is a rustacean among us!"),
            _ => println!("Hello {}", name),
        }
    }
    
    // iter_mut 可变地借用集合中的元素，允许集合就地被修改
    let names3 = vec!["bob", "frank", "ferris"];
    
    for name int names3.iter_mut() {
        *name = match name {
            &mut "Ferris" => "There is a rustacean among us!",
            _ => "Hello",
        }
    }
    println!("names: {:?}", names);
    
}
```



### 3.5 match 匹配-重要

- 解构
- 卫语句
- 绑定 @

```rust 
// match 解构
// 
// - 解构元组
fn main() {
    let triple = (0, -2, 3);
    
    // match 可以结构一个元组
    match triple {
        (0, y, z) => println!("First is 0, y is{:?}, z is {:?}",y,z),
        (1, ..) =>  println!("First is `1` and the rest doesn't matter"),
         _      => println!("It doesn't matter what they are"),
    }
}

// - 解构枚举
#[allow(dead_code)]
enum Color {
    // 这三个取值由他们的名字指定，不是类型
    Red,
    Blue,
    Green,
    // 将u32元组赋予不同的名字
    RGB(u32,u32,u32),
    HSV(u32,u32,u32),
}
fn main() {
    // 将不同的值赋予color
    let color = Color::RGB(122,12,10);
    // 使用match 解构 enum
    match color {
        Color::Red => println!("The color is Red!"),
        Color::Blue => println!("The color is Blue"),
        Color::RGB(r, g, b) =>
            println!("Red: {}, green: {}, and blue: {}!", r, g, b),
        Color::HSV(h, s, v) =>
            println!("Hue: {}, saturation: {}, value: {}!", h, s, v),
    }
}

// - 解构   指针和引用
//  注意区分 解构 和 解引用 的概念
//  解引用 使用 *
//  解构 使用 &， ref,  ref mut
fn main() {
    // 获取一个引用, &标识取引用
    let reference = &5;
    
    match reference {
        // val 表示 reference 引用的值 4
        &val => println!("got a value {:?}", val),
    }
    
    // 不使用 & ， 需要匹配前解引用
    match *reference {
        val => println!("got a value {:?}", val),
    }
    
    // 如果一开始不使用引用类型
    let _not_a_reference = 3;
    
    // rust 提供了ref, 更改了赋值行为，从而可以对具体的值创建引用
    let ref _is_a_reference = 3;
    
    // 相应的，定义两个非引用的变量，通过 ref , ref mut 仍然可以取得引用
    let value = 5;
    let mut mut_value = 6;
    
    match value {
        ref r => println!("Got a reference to a value: {:?}", r),
    }
    
    match mut_value {
        ref mut m => {
            *m += 10;
            println!("{:?}", m);
        }
    }
}

// - 解构结构体
fn main() {
    struct Foo {x: (u32,u32), y: u32}
    
    let foo = Foo{x: (1,2), y:3};
    // 解构结构体成员
    let Foor{x: (a,b), y} = foo;
    println!("a = {}, b = {},  y = {} ", a, b, y);
    
    // 可以解构结构体并重命名变量，成员顺序并不重要
    let Foo { y: i, x: j } = foo;
    println!("i = {:?}, j = {:?}", i, j);

    // 也可以忽略某些变量
    let Foo { y, .. } = foo;
    println!("y = {}", y);

    // 这将得到一个错误：模式中没有提及 `x` 字段
    // let Foo { y } = foo;
}

// - 卫语句 （相当条件）
fn main() {
    let pair = (2, -2);
    
    match pair {
        (x,y) if x==y => println!("These are twins"),
        (x,y) if x+y ==0 => println!("Antimatter, kaboom!"),
        // if 条件部分就是一个卫语句
        _ => println!("No correlation..."),
    }
}

// - match 绑定@ ： 绑定变量到名称
fn age() -> u32 {
    15
}
fn main() {
    match age() {
        0 =>  println!("I haven't celebrated my first birthday yet"),
        n @ 1..=12 => println!("I'm a child of age {:?}", n),
        n @ 13..=19 => println!("I'm a teen of age {:?}", n),
        // 不符合上面的范围。返回结果。
        n             => println!("I'm an old person of age {:?}", n),
    }
}
// 绑定也可以用到 enmu 上
fn some_number() -> Option<u32> {
    Some(42)
}
fn mian() {
    match some_number() {
        Some(n @ 42) =>  println!("The Answer: {}!", n),
        Some(n) => println!("Not interesting... {}", n),
        _ => (),
    }
}
```



### 3.6 if let

```rust
// 有时候match 匹配并不优雅
fn main() {
    let optional = Some(7);
    match optional {
        Some(i) => {
            // 这里从 optional 中解构出 `i`。
            println!("This is a really long string and `{:?}`", i)
        },
        _ => {},
    }
    
    // 对比一下 if let 
    let number = Some(7);
    // 将number 解构成 Some(i) 则执行语句块 {}
    if let Some(i) = number {
        println!("match {:?}", i);
    }
    
    // 如果要指出失败的情况，加上else即可
    if let Some(i) = number {
         println!("match {:?}", i);
    }else {
        // 解构失败的时候处理
          println!("Didn't match a number. Let's go with a letter!");
    }
}

// if let 匹配任何枚举
enum Foo {
    Bar,
    Baz,
    Qux(u32),
}
fn main() {
    let a = Foo::Bar;
    let c = Foo::Qux(100)
    // a变量匹配到Foo::Bar上
    if let Foo::Bar = a {
        println!("a is foobar");
    }
    // c 变量匹配到 Foo::Qux
    if let Foo::Qux(value) = c {
        println!("c is {}", value);
    }
}

```



### 3.7 while let

```rust
// while let 也可使得 match 更加的优雅
// 对比以下代码

let mut option = Some(0);
loop {
    match option{
        Some(i) => {
            if i > 9 {
                println!("Greater than 9, quit!");
                optional = None;
            }else {
                println!("`i` is `{:?}`. Try again.", i);
                optional = Some(i + 1);
            }
        },
        // 解构失败退出循环
        _ => {break}
    }
}

// 使用 while let 优化
// let 将 option 解构成 Some(i)时候就 执行语句块 {}
// 否则就 break
while let Some(i) = option {
    if i > 9 {
        println!("Greater than 9, quit!");
        optional = None;
     }else {
         println!("`i` is `{:?}`. Try again.", i);
         optional = Some(i + 1);
     }
}
```



# 4 函数

### 4.1 函数

```rust
fn main() {
    fuzzbuzz(100);
}

fn fizzbuzz(n: u32) -> () {
    ....
}
```



### 4.2 方法

```rust
// 方法是依附在对象的函数，通过 self 来访问数据，定义在impl中

// 例子
struct Point{
    x: f64,
    y: f64,
}

// 实现
impl Point {
    // 静态方法 static method
    // 构造器（constructor）
    fn origin() -> Point {
        Point { x: 0.0, y: 0.0}
    }
    // 另外一个静态方法
    fn new(x: f64, y: f64) -> Point {
        Point{x: x, y: y}
    }
}

struct Rectangle {
    p1: Point,
    p2: Point,
}
impl Rectangel {
    fn area(&self) -> f64 {
        let Point {x: x1, y: y1} = self.p1;
        let Point {x: x2, y: y2} = self.p2;
        
        ((x1-x2) * (y1-y2)).abs()
    }
    fn translate(&mut self, x: f64, y: f64) {
        self.p1.x += x;
        ...
    }
}
```



### 4.3 闭包

- 简单使用
- 捕获变量
- 类型匿名
- 闭包/函数作为输入参数
- 闭包/函数作为输出参数

```rust
|val| val +x
fn main() {
    // 通过函数和闭包实现自增
    fn function(i: i32) -> i32 { i + 1}
    
    // 闭包是匿名的，我们将绑定到变量
    let closure_annotated = |i: i32| -> i32 {i + 1};
    
    // 调用函数和闭包
    let i = 1;
    println!("{}", function(i));
    println!("{}", closure_annotated(i));
}
```

```rust
// 闭包捕获变量  既可以 move, 又可以 borrow
// - &T
// - &mut T
// - T
// 优先通过引用捕获变量
fn main() {
    use std::mem;
    
    let color := String::from("green");
    
    // 闭包立刻借用color, color 一直保持借用状态直到 print 离开作用域
    let print = ||println!("{}", color);
    
    // 使用借用来调用闭包
    print();
    
    // color 可以再次被不可变借用， 因为闭包只有一个color 的不可变借用
    let _reborrow = &color;
    print();
}
```

闭包作为函数输入参数

```rust
- Fn: 表示捕获方式为通过引用（&T）的闭包
- FnMut: 表示捕获方式通过可变引用（&mut T）的闭包
- FnOnce: 表示捕获方式通过值（T）的闭包
// 是因为 &T 只是获取了不可变的引用，&mut T 则可以改变变量，T 则是拿到了变量的所有权而非借用。
// 满足使用需求的前提下尽量以限制最多的方式捕获
```



闭包作为函数返回参数

```rust
- Fn
- FnMut
- FnOnce
配合  move 关键字

fn creat_fn() -> impl Fn() {
    let text = "Fn".to_owned();
    
    move || println!("{}", text);
}

fn creat_fnmut() -> impl FnMut() {
    let text = "FnMut".to_owned();
    move || println!("This is a: {}", text)
} 

fn creat_fnonce() -> impl FnOnce() {
    let text = "FnOnce".to_owned();
    move || println!("This is a: {}", text)
}
```

### 4.4 迭代器/消费适配器/迭代适配器(std::iter)

- 迭代器 ： into_iter(),  iter(), iter_mut()
- 消费适配器: sum(),count(), any(),collect()
- 迭代适配器: map(), filter(),zip(),take(),rev()

```
map 会将迭代项按值传递，因此它传给闭包的是拥有所有权的值，而返回的也是拥有所有权的值
filter 传给闭包的则是迭代项的共享引用，因此如果迭代项的元素类型是&str，那么使用filter(|x| *x !="")时，这个x 是&&str，因此要解引用之后再对比是否等于空
```



#### 4.4.1 如何产生迭代器的

```rust
// into_iter()
// iter()
// iter_mut()
```

#### 4.4.2 配合各种适配器花式使用(很骚，贼喜欢)

```rust
```



### 4.5 高阶函数

```rust
// 输入一个或者多个函数
fn is_odd(n: u32) -> bool {
    n %2 == 1
}
fn main() {
    // let upper = 1000;
    
    // 函数式写法
    let sum_of_squared_odd_numbers: u32 =
    	(0..).map(|n| n * n)
    		 .take_while(|&n| n < upper)
             .filter(|&n| is_odd(n))
             .fold(0, |sum, i| sum + i);
    
}
```

note: 发散函数

# 5 模块划分

  ### 5.1 mod

### 5.2 文件作为模块

### 5.3 目录作为模块



#  6 泛型 

### 6.1 泛型函数

```rust
fn generic<T>(_s: T) {}
```

###  6.2 泛型实现

```rust
// 泛型结构体
struct GenVal<T> {
    gen_val: T
}

// impl  指定 T 为泛型类型
impl <T> GenVal<T> {
    fn value(&self) -> &T {
        &self.gen_val
    }
}

```

### 6.3 泛型trait

```rust
// trait 也可以是泛型， 例如下面
// 不可以复制类型
struct Empty;
struct Null;

// T 的泛型 trait
trait DoubleDrop<T> {
    // 定义一个方法， 传入T
    fn doubel_drop(self, _: T);
}

impl <T, U> DoubleDrop<T> for U {
    fn doubel_drop(self, _: T){}
}
```



### 泛型约束 -重要

```rust
// 1 限定类型实现的功能
struct S<T: Display>(T);

// 2 泛型实力可以访问作为约束的trait方法
use std::fmt::Debug;

trait HasArea {
    fn area(&self) -> f64;
}
impl HasArea for Rectangle {
    fn area(&self) -> f64 {self.length *self.height}
}

#[derive[Debug]]
struct Rectangle {length: 664, height: f64}

// 泛型 `T` 必须实现 `Debug` 。只要满足这点，无论什么类型
// 都可以让下面函数正常工作。
fn print_debug<T: Debug>(t: &T) {
    println!("{:?}", t);
}

// 3 空约束
struct Cardinal;

trait Red{}

impl Red for Cardinal {}

// 4 多重约束
use std::fmt::{Debug, Display};

fn compare_prints<T: Debug + Display>(t: &T) {
    ...
}

// 5 where 优化多重约束
impl <A: TraitB + TraitC, D: TraitE + TraitF > Mytrait<A,D> for YourType {}

impl <A, D> Mytrait<A,D> for yourTypr
	where A: TraitB + TraitC,
          D: TraitE + TraitF {}


```

### 关联项

```rust
// `A` 和 `B` 在 trait 里面通过 `type` 关键字来定义。
trait Contains {
    type A;
    type B;
    
    fn contains(&self, &Self::A, &Self::B) -> bool;
}
```



# 7 作用域规则

## 7.1 所有权

1. rall 资源获取即初始化
2. 所有权, 移动, 可变性，部分移动

```rust
// 1 变量要负责释放他们所拥有的资源，所有资源拥有一个所有者。
//   在进行赋值 let x=y, 或者通过值传递函数参数(foo(x)),
//   资源的所有权会发生转移， rust中这叫资源的移动（move）
//   移动之后，原来的所有者不再有使用权。
fn main() {
    // 栈分配的资源
    let x = 5u32;
    
    // 将x 复制到 y  不存在资源的移动
    let y = x;
}

// 2 当所有权转移的时候， 数据的可变性可能发生改变
fn main() {
    let imutable_box = Box::new(5u32);
    
    // 可变性错误
    // *imutable_box = 4;
    
    // 所有权移动， 改变了可变性
    let mut mutable_box = imutable_box;
    
    *mutable_box = 10;
    println!("mutable_box now contains {}", mutable_box);
}

// 3 在单个变量的解构中，可以同时使用by-move, by-reference 模式绑定
//   这样可能有写变量所有权移动，而有些不变。父级可以使用没有被移动的部分。
fn main() {
    #[derive(Debug)]
    struct Person {
        name: String,
        arg: u8,
    }
    let person = PerSon{
      name: String::from("Alice"),
      age: 20,
    };
    
    // name 从 person  中移走， 但age 只能是引用
    let Person {name, ref age} = person;
   
    // 报错！部分移动值的借用：`person` 部分借用产生
    //println!("The person struct is {:?}", person);
    
    // person.age 还是可以使用的
    
}
```

## 7.2 借用

1. 借用机制。&T

```rust
// 多数我们更多是访问数据，同时不需要获得所有权
// rust提供了借用机制（borrowing），通过 &T 进行传递

// 函数取得一个 box 的所有权并销毁他
// 函数本身就是一个作用域
fn eat_box_i32(boxed_i32: Box<i32>) {
	println!("Destroying box that contains {}", boxed_i32);   
}

// 此函数借用一个 i32类型
fn borrow_i32(borrowed_i32: &i32) {
    println!("{}", borrowed_i32);
}
```

2. 可变借用。&mut T

```rust

```

3. 借用规则。

```rust
// 同一时间内只允许一次可变借用。仅当最后一次使用可变引用之后，原始数据才可以再次借用。
```

4. ref模式。

```rust
// 在通过 let 绑定来进行模式匹配或解构时，ref 关键字可用来创建结构体/元组的 字段的引用
```



## 7.3 生命周期

**生命周期**（lifetime）是这样一种概念，编译器（中的借用检查器）用它来保证所有的 借用都是有效的。确切地说，一个变量的生命周期在它创建的时候开始，在它销毁的时候 结束。虽然生命周期和作用域经常被一起提到，但它们并不相同。

借用拥有一个生命周期，此生命 周期由它声明的位置决定。于是，只要该借用在出借者（lender）被销毁前结束，借用 就是有效的。然而，借用的作用域则是由使用引用的位置决定的。



借用拥有一个生命周期， 是由他的声明位置决定。

借用的作用域是由使用使用的位置决定的。



- 函数  lifestyle

```rust
// - 任何引用都要有标注好的生命周期
// - 任何被返回的引用都必须有和某个输入量相同的生命周期或者是 静态类型（static）
// - 如果没有输入的函数返回引用，有时候返回引用指向无效数据

// 一个拥有生命周期 `a 的输入引用， 其中存活时间至少与函数一样长
fn print_one<'a>(x: &'a i32) {
    println!("x is {}", x);
}

// 可变引用同样也有生命周期
fn add_one<'a>(x: &'a mut i32) {
    *x += 1;
}

// 不同生命周期的元素
fn print_multi<'a, 'b>(x: &'a, y: &'b i32){
    println!("x is {}, y is {}", x, y);
}

// 返回传递进来的引用也可以
fn pass_x<'a, 'b>(x: &'a i32, y: &'b i32) -> &'a i32 { x }

// fn invalid_output<'a>() -> &'a String { &String::from("foo")}
// 无效代码，数据离开作用域删掉， 返回一个指向无效数据的作用

fn main() {
    let x = 7;
    let y = 9;
    
    print_one(&x);
    print_multi(&x, &y);
    
    let z = pass_x(&x, &y);
    
    let mut t= 3;
    add_one(&mut t);
    print_one(&t);
}
```

- 方法  lifestyle

```rust
// 方法一般是不需要标明生命周期的，因为 self 的生命周期会赋给所有的输出 生命周期参数
```



- 结构体/枚举  lifestyle

```rust

// 这两个引用的生命周期都必须比这个结构体长
#[derive(Debug)]
struct NameBorrowed<'a> {
    x: &'a i32,
    y: &'a i32,
}

#[derive(Debug)]
enum Either<'a> {
    Num(i32),
    Ref(&'a i32`)
}
```

- trait

```rust
// trait 方法中生命期的标注基本上与函数类似。注意，impl 也可能有生命周期的标注。
#[derive(Debug)]
struct Borrowed<'a> {
    x: &'a i32,
}

// 给 impl 标注生命周期
impl<'a> Default for Borrowd<'a> {
    fn default() -> Self {
        Self { x: &10}
    }
}
```

- 约束

```rust
// 就如泛型一样被约束， 生命周期（本质就是泛型）也可以使用约束
// T: 'a : T 中的所有引用都比生命周期‘a 更长
// T: trait + 'a 类型必须实现 Trait trait，并且在 T 中的所有引用 都必须比 'a 活得更长

use std::fmt::Debug; 

#[derive(Dedug)]
struct Ref<'a, T: 'a>(&'a T);

fn print<T>(t: T) where 
	T: Debug {
    println!("{:?}", t);        
} 

fn print_ref<'a, T>(t: &'a T) where
	T: Debug + 'a {
      println!("`print_ref`: t is {:?}", t);  
}
```

- 强制转化 较长的生命周期转换成一个较短的生命周期

```rust 
// <'a: 'b, 'b> 生命周期 `'a` 至少和 `'b` 一样长
// 在这里我们我们接受了一个 `&'a i32` 类型并返回一个 `&'b i32` 类型，这是
// 强制转换得到的结果。
fn choose_first<'a: 'b, 'b>(first: &'a i32, _: &'b i32) ->&'b i32 {first}
```

- static
- 省略



# 8 特征trait 

### 8.1 特征trait

`trait` 是对未知类型 `Self` 定义的方法集。该类型也可以访问同一个 trait 中定义的 其他方法。

### 8.2 派生derive

```rust
#[derive(Debug)]
// - 可以自动派生的trait
// 比较相关的trait： Eq, PartialEq, Ord, PartialOrd
// Clone 从&T 创建副本T
// Copy  使类型具有“复制语义” 而非 “移动语义”
// Hash  从&T计算哈希值hash
// Default 创建数据类型的一个空实例
// Debug 使用{:?} formatter 格式化一个值
```

### 8.3 动态返回trait

```rust
// 函数返回类型需要明确的内存，当返回trait的时候
// 一般的处理是使用  Box<dyn xxTrait>
fn random_animal(random_number: f64) -> Box<dyn Animal> {
}
```

### 8.4 impl trait

### 8.5 组合 trait

## 8.6 常见的trait

### drop

### clone

### iterator

### 消除重叠的trait - 完全限定语法

# 9 错误处理

### 9.1 Option<T>

```rust

```

### 9.2 Result<T,E>

```rust
// unwrap 如果Ok, 返回Ok的值， 如果Err,则调用panic
// expect 出错则直接panic
// ? 出错则直接返回错误
use std::fs::File;
use std::io;
use std::io::Read;

fn read_unsename_from_file() -> Result<String, io::Error> {
    let mut s = String::new();
    
    File::open("hello.txt")?.read_to_string(&mut s)?;
}
```

### 9.3 Panic

```10 rust
fn main() {
    panic!("xxx");
}
```

# 10 宏编程



# 11  属性

- [内置属性](https://rustwiki.org/zh-CN/reference/attributes.html#built-in-attributes-index)
- [宏属性](https://rustwiki.org/zh-CN/reference/procedural-macros.html#attribute-macros)
- [派生宏辅助属性](https://rustwiki.org/zh-CN/reference/procedural-macros.html#derive-macro-helper-attributes)
- [外部工具属性](https://rustwiki.org/zh-CN/reference/attributes.html#tool-attributes)

## 11.1 内置属性（重点）

### 11.1.1 条件编译

### 11.1.2 测试

### 11.1.3 派生

### 11.1.4 宏

### 11.1.5 诊断

### 11.1.6 ABI,链接,符号,FFI

### 11.1.7 代码生成

### 11.1.8 文档

### 11.1.9 预导入包（preludes）

### 11.1.10 模块

### 11.1.11 特性

### 11.1.12 极限设置

### 11.1.13 运行时

### 11.1.14 类型系统



 










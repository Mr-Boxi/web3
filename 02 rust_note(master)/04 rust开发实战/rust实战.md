# rust 库实战

rust实战就是各种库的使用 (标准库，第三方库)

## 1 标准库类型

### 1.1 Box,栈，堆

所有值默认栈分配，通过Box<T>,把值装箱使它在堆上分配。

被装箱的值可以通过 * 运算符进行解引用

```rust

```

### 1.2 动态数组vector

vertor是一个大小可变的数组。类比golang的slice。{指针，长度，容量}

```rust
fn main() {
    // 迭代器可以被收集到vector中
    let collected_iterator: Vec<i32> = (0..10).collect();
    println!("{:?}", collected_iterator);
	
    // vec! 可以用来初始化一个 vertor
    let mut xs = vec![1i32, 2, 3];
    println!("Initial vector: {:?}", xs);
    
    // 在vertor的尾部插入一个元素
    xs.push(4);
    
   	// 报错代码! 不可变vector 不可以增长
    collected_iterator.push(0);
    
    // len 可以获得一个 vector的大小
    xs.len()
    
    // pop 移除最后一个元素，并返回这个移除的值
    xs.pop()
    
    // 超出下标报panic
    
    // 迭代一个 vector 很方便
    for x in xs.iter() {
        println!("{}", x);
    }
    
    // 可以使用i 来记录 迭代次数
    for (i, x) in xs.iter().enumerate() {
        println!("In position {} we have value {}", i, x);
    }
    
    // 使用 iter_mut, 在迭代的同时可以修改每个值
    for x in xs.iter_mut() {
        *x *= 3
    }
}
```

### 1.3 字符串 string

rust 中有两种字符串： string  和 &str

String:  存储为vector(Vec<u8>)， 是在堆分配

&str:  是一个指向有效 UTF-8 的序列切片（&[u8]）

```rust
fn main() {
    // 一个对只读内存分配的字符串引用
    let pangram: &' static str = "the quick brown fox jumps over the lazy dog"
    println!("{}", pangram);
    
    // 逆序迭代单词， 这里并没有分配新的字符串
    for word in pangram.split_whitespace().rev() {
        println!("{}", word);
    }
    
    // 复制字符到一个vector, 排序并移除重复值
    let mut chars: Vec<char> = pangram.chars().collect();
    
    chars.sort();
    chars.dedup();
    
    // 创建空的且可以增长的 String
    let mut string = String::new();
    for c in chars {
        string.push(c)
        string.push_str(", ")
    }
    
    // 堆分配一个字符串
    let alice = String::from("i like rust");
    // 分配新的内存并存储修改过的字符串
    let bob: String = alice.replace("rust", "rust_1");
}
```

### 1.4 散列表 HashMap

- k, v 键值对

```rust
fn main() {
    let mut contacts = HashMap::new();
    
    contacts.insert("Danile","22");
    contacts.insert("Ashley","23");
    
    // 移除
    contacts.remove(&("Ashley")); 
}
```

- HashSet   HashMap<T, ()>

```rust

```



### 1.5 选项 Option 

Option<T> 有两个变体

- None 表示失败或者是缺少值
- Some(value)  元组结构，封装一个T 类型的值

// 解包 `None` 将会引发 `panic!`。

// 解包 `Some` 将取出被包装的值

```rust
// 不会 panic 的整除法
fn checked_division(divided: i32, divisor: i32) -> Option<i32> {
    if divisor == 0 {
        None
    } else {
        Some(divided / divisor)
    }
}

// 处理可能失败的除法
fn try_division(divided: i32, divisor: i32) {
    match checked_division(divided, divisor) {
        None => println!("{} / {} failed!", dividend, divisor),
        Some(quotient) => {
            println!("{} / {} = {}", dividend, divisor, quotient)
        },
    }
}
```

### 1.6 结果 Result

Result<T, E>

- Ok(value)  操作成功，并包装操作返回val
- Err(why)  操作失败，并包装 `why`，它（但愿）能够解释失败的原因（`why` 拥有 `E` 类型

```rust

```

### 1.7 及早返回运算符号 ?

`?` 运算符用在返回值为 `Result` 的表达式后面，它等同于这样一个匹配 表达式：其中 `Err(err)` 分支展开成提前返回的 `return Err(err)`，而 `Ok(ok)` 分支展开成 `ok` 表达式。

```rust

```

### 1.8 panic! 

产生一个panic

### 1.9 引用计数器 Rc

需要多个所有权时候使用

```rust

```

### 1.10共享引用计数器 Arc

线程之间需要共享时候可以使用Arc (atomic reference counted)

使用clone 方法创建一个引用指针，同时增加引用计数。 

## 2 标准库拓展

### 2.1 文件输入输出

(1) 打开文件 open

```rust
use std::error::Error;
use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

fn main() {
    // 创建指向文件的路径
    let path = Path::new("hello.txt");
    let display = path.display();
    
    // 只读模式打开， 返回io::Result<File>
    let mut file = match Fils::open(&path) {
        Err(why) => panic!("could's read{}:{}", display, why.description()),
        Ok(fils) => file,
    };
    
    // 读取文件中的内容到一个字符串中， 返回 io::Result<usize>
    let mut s = String::new();
    match fils.read_to_string(&mut s) {
        Err(why) => panic!("couldn't read {}: {}", display,
                                                   why.description()),
        Ok(_) => print!("{} contains:\n{}", display, s),
    }
    
    // file 离开作用域， 文件关闭
}
```

（2）创建文件 create

```rust
static LOREM_IPSUM: &'static str =
"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
";

use std::error::Error;
use std::io::prelude::*;
use std::fs:File;
use std::path:Path;

fn mian() {
    let path = Path::new("out/lorem.txt");
    let display = path.display();
    
    // 只写模式打开文件
    let mut file = match File::creat(&path) {
        Err(why) => panic!("couldn't create {}: {}",
                           display,
                           why.description()),
        Ok(file) => file,
    };
    
    // 写进file
    match file.write_all(LOREM_IPSUM.as_bytes()) {
        Err(why) =>{ 
            panic!("couldn't write to {}: {}", display,
                                               why.description())
        },
        Ok(_) => println!("successfully wrote to {}", display),
    }
}
```

(3) 读取行 lines()

```rust
use std::fs::File;
use std::io::(self, BufRead);
use std::path::Path;

fn main() {
    if let Ok(lines) = read_lines("./hosts") {
        for line in lines {
            if let Ok(ip) = line {
                println!("{}", ip);
            }
        }
    }
}
// 输出包裹在 Result 中以允许匹配错误，
// 将迭代器返回给文件行的读取器（Reader）。
fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
```



### 2.2 文件系统操作

```rust

```



### 2.3 线程

spawn 函数创建本地系统原生线程机制

```rust
use std::thread;

static NTHREAD: i32 = 10;

fn main() {
    // 使用vector 存放子进程
    let mut children = vec![];
    
    for i in 0..NTHREAD {
        // 创建子进程
        children.push(thread::spawn(
        	move || {
                println!("this is thread number {}", i);
            }
        ));
    }
    for child in children {
        // 等待线程结束。返回一个结果
        let _ = child.join();
    }
}
```

- map-reduce



```rust

```



### 2.4 管道

线程之间异步通信

```rust
use std::sync::mpsc::{Sender, Receiver};
use std::sync::mpsc;
use std::thread;

static NTHREADS: i32 = 3;

fn main() {
    let (tx, rx): (Sender<i32>, Receiver<i32>) = mpsc::channel();
    for id in 0..NTHREADS {
        // sender 端可以复制
        let thread_tx = tx.clone();
        
        // 每个线程都将通过通道发送id
        thread::spawn(move || {
            //被创建的线程取得thread_tx` 的所有权
            thread_tx.send(id).unwrap();
            
            // 发送是非阻塞操作
            println!("thread {} finished", id);
        });
    }
    
    // 所有消息在此处被收集
    let mut ids = Vec::with_capacity(NTHREADS as usize);
    for _ in 0..NTHREADS {
        ids.push(rx.recv());
    }
    // 显示消息被发送的次序
    println!("{:?}", ids);
}
```



### 2.5 子进程

###  2.6 路径

`Path` 结构体代表了底层文件系统的文件路径。 posix::path， windows::path

```rust
use std::Path::Path;

fn main() {
    // 从 &‘static str 创建一个 path
    let path = Path::new(".");
    
    // display 显示
    let display = path.display();
    
    // join 使用操作系统的分隔符号合并路径
    let new_path = path.join("a").join("b");  // ./a/b
    
    // 将路径转换成一个字符切片
    match new_path.to_str() {
        None => panic!("new path is not a valid UTF-8 sequence"),
        Some(s) => println!("new path is {}", s),
    }
    
}
```



### 2.7 程序参数

- 使用env::args() 获取传入参数

```rust
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    
    println!("my path is {}", args[0]);
   
}
```



## 3 结构体的序列化/反序列化

```rust
// - json, toml
[dependencies]
serde = "1.0.84"
serde_derive = "1.0.84"
serde_json = "1.0.36"

// main.rs
user serde_derive::{Serialize,Deserialize};

#[derive(Debug, Serialize, Deserizlize)]
struct Foo {
    a: String,
    b: u64,
}

impl Foo {
    fn new(a: &str, b: u64) -> Self {
        Self {
            a: a.to_string(),
            b
        }
    }
}
fn main() {
    let foo_json = serde_json::to_string(Foo::new("simple", 101)).unwrap();
	println!("{:?}", foo_json);
    
    let foo_value: Foo = serde_json::form_str(foo_json).unwrap();
}
```



# CodeBook 实战

本目录下的文件夹 codebook

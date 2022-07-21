# 通过evm库学习rust 

纯rust 实现的evm库： https://github.com/rust-blockchain/evm

## 1 总体结构

````````````
层层封装： 最底层是core, runtime 对core封装， executor 对 runtime + gasometer 封装
```````````
|  core   |
```````````
| runtime |
```````````
| executor|
```````````
````````````

1. 先看根目录的cargo.toml

```
# 依赖库
[dependencies]
log = { version = "0.4", default-features = false }
evm-core = { version = "0.35", path = "core", default-features = false }
evm-gasometer = { version = "0.35", path = "gasometer", default-features = false }
evm-runtime = { version = "0.35", path = "runtime", default-features = false }
sha3 = { version = "0.10", default-features = false }
rlp = { version = "0.5", default-features = false }
primitive-types = { version = "0.11", default-features = false, features = ["rlp"] }
serde = { version = "1.0", default-features = false, features = ["derive"], optional = true }
codec = { package = "parity-scale-codec", version = "3.0", default-features = false, features = ["derive"], optional = true }
ethereum = { version = "0.12", default-features = false }
environmental = { version = "1.1.2", default-features = false, optional = true }
scale-info = { version = "2.0.0", default-features = false, features = ["derive"], optional = true }
auto_impl = "0.5.0"

# 工作空间- 表示有4个crate
[workspace]
members = [
  "core",
  "gasometer",
  "runtime",
  "fuzzer"
]
```

2. 根目录evm库 结构 --src/lib.rs

```
- backend 
- executor
- tracing

# 重导出
- evm_core
- evm_gasometer
- evm_runtime
```

## 2 evm_core crate 

### 2.1 lib.rs 模块

1 条件编译

```rust
#![deny(warnings)]  // 编译遇到warning就报告错误
#![forbid(unsafe_code, unused_variables, unused_imports)]
#![cfg_attr(not(feature = "std"), no_std)]
```

2  预导入

```
extern crate alloc;
extern crate core;
```

3 模块定义，重导出，使用

```
// 定义
mod xxx; 定义一个模块

// 重导出
pub use xxx;

// 使用
use alloc::rc::Rc;
...
```

4 定义结构体

```rust
pub struct Machine {
	/// Program data.
	data: Rc<Vec<u8>>,
	/// Program code.
	code: Rc<Vec<u8>>,
	/// Program counter.
	position: Result<usize, ExitReason>,
	/// Return value.
	return_range: Range<U256>,
	/// Code validity maps.
	valids: Valids,
	/// Memory.
	memory: Memory,
	/// Stack.
	stack: Stack,
}
impl Machine { 
	xxx 一系列代码块
}
```

### 2.2 error 错误模块

1 类型别名

```
pub type Trap = Opcode;
```

2枚举

```
/// 执行结果
/// Capture represents the result of execution.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Capture<E, T> {
	/// The machine has exited. It cannot be executed again.
	Exit(E),
	/// The machine has trapped. It is waiting for external information, and can
	/// be executed again.
	Trap(T),
}

/// 退出原因
/// Exit reason.
#[derive(Clone, Debug, Eq, PartialEq)]
#[cfg_attr(
	feature = "with-codec",
	derive(codec::Encode, codec::Decode, scale_info::TypeInfo)
)]
#[cfg_attr(feature = "with-serde", derive(serde::Serialize, serde::Deserialize))]
pub enum ExitReason {
	/// Machine has succeeded.
	Succeed(ExitSucceed),
	/// Machine returns a normal EVM error.
	Error(ExitError),
	/// Machine encountered an explicit revert.
	Revert(ExitRevert),
	/// Machine encountered an error that is not supposed to be normal EVM
	/// errors, such as requiring too much memory to execute.
	Fatal(ExitFatal),
}
```

### 2.3 memory 模块

```rust
/// A sequencial memory. It uses Rust's `Vec` for internal
/// representation.
#[derive(Clone, Debug)]
pub struct Memory {
	data: Vec<u8>,
	effective_len: U256,
	limit: usize,
}
impl Memory { ... }

#[inline]  // 内联优化
fn next_multiple_of_32(x: U256) -> Option<U256>
```

### 2.4 opcode 模块

```rust
/// evm 虚拟机的指令集
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct Opcode(pub u8);
impl Opcode { xxx }
```

### 2.5 stack 模块

```rust
// 栈
/// EVM stack.
#[derive(Clone, Debug)]
pub struct Stack {
	data: Vec<H256>,
	limit: usize,
}

```

### 2.6 valids 模块

```rust
/// Mapping of valid jump destination from code.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct Valids(Vec<bool>);
```

### 2.8 uitls 模块

```rust
#[derive(Copy, Clone, Eq, PartialEq, Debug)]
pub struct I256(pub Sign, pub U256);
```

### 2.9 eval 预估模块

```rust
// mod.rs
eval执行指令预

// arithmetic.rs
四则运算
// bitwish.rs
位运算
// macros.rs
宏
//misc.rs 
杂项
```

## 3 evm_runtime crate

### 3.1 lib.rs 模块

1 宏定义

```rust
macro_rules! step {}
```

2 evm runtime 结构体

```rust
/// EVM runtime.
///
/// The runtime wraps an EVM `Machine` with support of return data and context.
pub struct Runtime<'config> {
	machine: Machine,
	status: Result<(), ExitReason>,
	return_data_buffer: Vec<u8>,
	context: Context,
	_config: &'config Config,
}
impl<`config> Runtime<`config> {
    
}

/// Runtime configuration.
#[derive(Clone, Debug)]
pub struct Config { ... }
impl Config {}


struct DerivedConfigInputs {
	gas_storage_read_warm: u64,
	gas_sload_cold: u64,
	gas_access_list_storage_key: u64,
	decrease_clears_refund: bool,
	has_base_fee: bool,
	disallow_executable_format: bool,
}
impl DerivedConfigInputs{}
```

### 3.2 eval 预估模块

```rust
// mod.rs

// macros.rs

// system.rs

```

### 3.3 context 模块

```
/// Create scheme. 创建调度
#[derive(Clone, Copy, Eq, PartialEq, Debug)]
pub enum CreateScheme {
	/// Legacy create scheme of `CREATE`.
	Legacy {
		/// Caller of the create.
		caller: H160,
	},
	/// Create scheme of `CREATE2`.
	Create2 {
		/// Caller of the create.
		caller: H160,
		/// Code hash.
		code_hash: H256,
		/// Salt.
		salt: H256,
	},
	/// Create at a fixed location.
	Fixed(H160),
}

/// Call scheme.  执行调度
#[derive(Clone, Copy, Eq, PartialEq, Debug)]
pub enum CallScheme { ... }


/// Context of the runtime.
#[derive(Clone, Debug)]
pub struct Context { ... }
```

### handler

```
/// Transfer from source to target, with given value.
#[derive(Clone, Debug)]
pub struct Transfer 

/// EVM context handler.
#[auto_impl::auto_impl(&mut, Box)]
pub trait Handler {}
```

### interrupt

```rust
pub enum Resolve<'a, 'config, H: Handler> {}


/// Create interrupt resolution.
pub struct ResolveCreate<'a, 'config> {
	runtime: &'a mut Runtime<'config>,
}

/// Call interrupt resolution.
pub struct ResolveCall<'a, 'config>{}
```



## 4 evm_gasometer create



## 5 evm create

目录：src/*

### 5.1 lib 模块 

2.1.1 create 属性 [参考资料：https://www.hdboy.top/show/68]

```rust
#![deny(warnings)]
#![forbid(unsafe_code, unused_variables)]
#![cfg_attr(not(feature = "std"), no_std)]

解析：
`#!` 在create 前面代表以下属性应用到整个create中

#![deny(warnings)] // 表示构建不接受warning，遇到违反 C 的情况会触发编译器报错(signals an error)，
#![forbid(unsafe_code, unused_variables)] //forbid(C) 与 deny(C) 相同，但同时会禁止以后再更改 lint级别
#![cfg_attr(not(feature = "std"), no_std)] //条件编译-cfg_attr, 在禁用feature = “std",编译成no_std rust  参考文章： https://zhuanlan.zhihu.com/p/396407985


// 导入alloc 模块
extern crate alloc;

// 在启用 feature = "tracing" 特性才编译 tracing 模块
#[cfg(feature = "tracing")]
pub mod tracing;
```

2.1.1  模块重导出

```rust
pub mod xxx;  //将模块内容导出到当前的模块中
```

### 5.2  tracing 模块



### 5.3 backend 模块

#### mod.rs

```
pub struct Basic {}
pub enum Apply<I> {}
pub trait Backend {}
pub trait ApplyBackend {}
```

#### memory.rs

```rust
pub struct MemoryVicinity 
pub struct MemoryAccount
pub struct MemoryBackend<'vicinity>
```

### 5.3 executor 模块

#### mod.rs

```rust
pub use self::executor::{
	Accessed, PrecompileFailure, PrecompileFn, PrecompileOutput, PrecompileSet, StackExecutor,
	StackExitKind, StackState, StackSubstateMetadata,
};

pub use self::memory::{MemoryStackAccount, MemoryStackState, MemoryStackSubstate};
```

#### executor.rs

```rust

#[derive(Default, Clone, Debug)]
pub struct Accessed {
	pub accessed_addresses: BTreeSet<H160>,
	pub accessed_storage: BTreeSet<(H160, H256)>,
}

#[derive(Clone, Debug)]
pub struct StackSubstateMetadata<'config> {
	gasometer: Gasometer<'config>,
	is_static: bool,
	depth: Option<usize>,
	accessed: Option<Accessed>,
}

pub trait StackState<'config>: Backend {}


/// Stack-based executor.
pub struct StackExecutor<'config, 'precompiles, S, P> {
	config: &'config Config,
	state: S,
	precompile_set: &'precompiles P,
}

```

#### memory.rs

```rust
#[derive(Clone, Debug)]
pub struct MemoryStackAccount {
	pub basic: Basic,
	pub code: Option<Vec<u8>>,
	pub reset: bool,
}

#[derive(Clone, Debug)]
pub struct MemoryStackSubstate<'config> {
	metadata: StackSubstateMetadata<'config>,
	parent: Option<Box<MemoryStackSubstate<'config>>>,
	logs: Vec<Log>,
	accounts: BTreeMap<H160, MemoryStackAccount>,
	storages: BTreeMap<(H160, H256), H256>,
	deletes: BTreeSet<H160>,
}


#[derive(Clone, Debug)]
pub struct MemoryStackState<'backend, 'config, B> {
	backend: &'backend B,
	substate: MemoryStackSubstate<'config>,
}
```

## 总结

- [模块](https://rustwiki.org/zh-CN/reference/items/modules.html)
- [外部crate(`extern crate`)声明](https://rustwiki.org/zh-CN/reference/items/extern-crates.html)
- [`use`声明](https://rustwiki.org/zh-CN/reference/items/use-declarations.html)
- [函数定义](https://rustwiki.org/zh-CN/reference/items/functions.html)
- [类型定义](https://rustwiki.org/zh-CN/reference/items/type-aliases.html)
- [结构体定义](https://rustwiki.org/zh-CN/reference/items/structs.html)
- [枚举定义](https://rustwiki.org/zh-CN/reference/items/enumerations.html)
- [联合体定义](https://rustwiki.org/zh-CN/reference/items/unions.html)
- [常量项](https://rustwiki.org/zh-CN/reference/items/constant-items.html)
- [静态项](https://rustwiki.org/zh-CN/reference/items/static-items.html)
- [trait定义](https://rustwiki.org/zh-CN/reference/items/traits.html)
- [实现](https://rustwiki.org/zh-CN/reference/items/implementations.html)
- [外部块(`extern` blocks)](https://rustwiki.org/zh-CN/reference/items/external-blocks.html)


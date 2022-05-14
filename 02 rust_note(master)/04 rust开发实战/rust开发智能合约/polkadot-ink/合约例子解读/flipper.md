# flipper

一个简单的合约，仅仅保存一个状态值。

逐行代码解析合约

```rust
// lib.rs

#![cfg_attr(not(feature = "std"), no_std)]
/// #！ 模块注释
/// cfg_attr 条件编译属性
/// 不使用标准库模块

/// 这个属性表示这个模块是一个合约
#[inl::contract]
pub mod flipper {
    /// 表示一个存储， 存放进入区块中
    #[ink(storage)]
    pub struct Flipper {
        value: bool,
    }
    
    // 实现块
    impl Flipper {
        /// 表示构造函数
        #[ink(constructor)]
        pub fn new(init_value: bool) -> Self {Self {value: init_value}}
        
      	#[ink(constructor)]
        pub fn default() -> Self{ Self::new(Default::default())}
        
        /// message 表示通过详细调用合约，执行状态的更改
        #[ink(message)]
        pub fn flip(&mut self) {self.value = !self.value;}
        
        #[ink(message)]
        pub fn get(&self) -> bool {self.value}
    }
    
    /// 测试属性
    #[cfg(test)]
    mod tests {
        use super::*;
        use inl_lang as ink;
        
        // 测试函数
        #[ink::test]
        fn default_works() {
           let flipper = Flipper::default();
            assert!(!flipper.get());
        }
        
        #[ink::test]
        fn it_works() {
            let mut flipper = Flipper::new(false);
            assert!(!flipper.get());
            flipper.flip();
            assert!(flipper.get());
        }
    }
}
```


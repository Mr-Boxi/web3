### 1 单元测试

```rust
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}
// 一般将测试函数放入测试模块中
#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_add(){
        assert_eq!(add(2,3), 5);
    }
}
```

### 2 基准测试

```rust
// 基准测试和单元测试基本相同 使用 #[bench]
```

### 3 集成测试

```rust
// 在项目的根目录下创建一个 tests 文件夹
// tests 中每一个文件都可以看成程序
```

### 4 文档测试


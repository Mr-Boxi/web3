# cargo target

 **Cargo 项目中包含有一些对象，它们包含的源代码文件可以被编译成相应的包，这些对象被称之为 Cargo Target**



### 库对象

```toml
# 一个简单的例子：在 Cargo.toml 中定制化库对象
[lib]
crate-type = ["cdylib"]
bench = false
```

### 二进制对象

```toml
# Example of customizing binaries in Cargo.toml.
[[bin]]
name = "cool-tool"
test = false
bench = false

[[bin]]
name = "frobnicator"
required-features = ["frobnicate"]
```

### 示例对象

```toml
[[example]]
name = "foo"
crate-type = ["staticlib"]
```

### 测试对象

```bash
cargo test // 自动编译
```

### 基准测试

```bash
// benches 目录下
```


# 工作空间

一个工作空间是由多个 `package` 组成的集合，它们共享同一个 `Cargo.lock` 文件、输出目录和一些设置(例如 profiles : 编译器设置和优化)。组成工作空间的 `packages` 被称之为工作空间的成员。



### root package

```toml
[workspace]
members = [
  "crates/globset",
  "crates/grep",
  "crates/cli",
  "crates/matcher",
  "crates/pcre2",
  "crates/printer",
  "crates/regex",
  "crates/searcher",
  "crates/ignore",
]
```



### virtual manifest

```toml
[workspace]
members = ["xtask/", "lib/*", "crates/*"]
exclude = ["crates/proc_macro_test/imp"]
```


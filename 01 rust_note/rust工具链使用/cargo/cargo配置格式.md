# cargo.toml 列表
- - `[package]` — 定义项目 `package`)的元信息

  - [`name`](https://course.rs/cargo/reference/manifest.html#name) — 名称
  - [`version`](https://course.rs/cargo/reference/manifest.html#version) — 版本
  - [`authors`](https://course.rs/cargo/reference/manifest.html#authors) — 开发作者
  - [`edition`](https://course.rs/cargo/reference/manifest.html#edition) — Rust edition.
  - [`rust-version`](https://course.rs/cargo/reference/manifest.html#rust-version) — 支持的最小化 Rust 版本
  - [`description`](https://course.rs/cargo/reference/manifest.html#description) — 描述
  - [`documentation`](https://course.rs/cargo/reference/manifest.html#documentation) — 文档 URL
  - [`readme`](https://course.rs/cargo/reference/manifest.html#readme) — README 文件的路径
  - [`homepage`](https://course.rs/cargo/reference/manifest.html#homepage) - 主页 URL
  - [`repository`](https://course.rs/cargo/reference/manifest.html#repository) — 源代码仓库的 URL
  - [`license`](https://course.rs/cargo/reference/manifest.html#license和license-file) — 开源协议 License.
  - [`license-file`](https://course.rs/cargo/reference/manifest.html#license和license-file) — License 文件的路径.
  - [`keywords`](https://course.rs/cargo/reference/manifest.html#keywords) — 项目的关键词
  - [`categories`](https://course.rs/cargo/reference/manifest.html#categories) — 项目分类
  - [`workspace`](https://course.rs/cargo/reference/manifest.html#workspace) — 工作空间 workspace 的路径
  - [`build`](https://course.rs/cargo/reference/manifest.html#build) — 构建脚本的路径
  - [`links`](https://course.rs/cargo/reference/manifest.html#links) — 本地链接库的名称
  - [`exclude`](https://course.rs/cargo/reference/manifest.html#exclude和include) — 发布时排除的文件
  - [`include`](https://course.rs/cargo/reference/manifest.html#exclude和include) — 发布时包含的文件
  - [`publish`](https://course.rs/cargo/reference/manifest.html#the-publish-field) — 用于阻止项目的发布
  - [`metadata`](https://course.rs/cargo/reference/manifest.html#metadata) — 额外的配置信息，用于提供给外部工具
  - [`default-run`](https://course.rs/cargo/reference/manifest.html#default-run) — [`cargo run`] 所使用的默认可执行文件( binary )
  - [`autobins`](https://course.rs/cargo/reference/cargo-target.html#对象自动发现) — 禁止可执行文件的自动发现
  - [`autoexamples`](https://course.rs/cargo/reference/cargo-target.html#对象自动发现) — 禁止示例文件的自动发现
  - [`autotests`](https://course.rs/cargo/reference/cargo-target.html#对象自动发现) — 禁止测试文件的自动发现
  - [`autobenches`](https://course.rs/cargo/reference/cargo-target.html#对象自动发现) — 禁止 bench 文件的自动发现
  - [`resolver`](https://course.rs/cargo/reference/resolver.html#resolver-versions) — 设置依赖解析器( dependency resolver)

- Cargo Target 列表: (查看

   

  Target 配置

   

  获取详细设置)

  - [`[lib\]`](https://course.rs/cargo/reference/cargo-target.html#库对象library) — Library target 设置.
  - [`[[bin\]]`](https://course.rs/cargo/reference/cargo-target.html#二进制对象binaries) — Binary target 设置.
  - [`[[example\]]`](https://course.rs/cargo/reference/cargo-target.html#示例对象examples) — Example target 设置.
  - [`[[test\]]`](https://course.rs/cargo/reference/cargo-target.html#测试对象tests) — Test target 设置.
  - [`[[bench\]]`](https://course.rs/cargo/reference/cargo-target.html#基准性能对象benches) — Benchmark target 设置.

- Dependency tables:

  - [`[dependencies\]`](https://course.rs/cargo/reference/specify-deps.html) — 项目依赖包
  - [`[dev-dependencies\]`](https://course.rs/cargo/reference/specify-deps.html#dev-dependencies) — 用于 examples、tests 和 benchmarks 的依赖包
  - [`[build-dependencies\]`](https://course.rs/cargo/reference/specify-deps.html#build-dependencies) — 用于构建脚本的依赖包
  - [`[target\]`](https://course.rs/cargo/reference/specify-deps.html#根据平台引入依赖) — 平台特定的依赖包

- [`[badges\]`](https://course.rs/cargo/reference/manifest.html#badges) — 用于在注册服务(例如 crates.io ) 上显示项目的一些状态信息，例如当前的维护状态：活跃中、寻找维护者、deprecated

- [`[features\]`](https://course.rs/cargo/reference/features/intro.html) — `features` 可以用于条件编译

- [`[patch\]`](https://course.rs/cargo/reference/deps-overriding.html) — 推荐使用的依赖覆盖方式

- [`[replace\]`](https://course.rs/cargo/reference/deps-overriding.html#不推荐的replace) — 不推荐使用的依赖覆盖方式 (deprecated).

- [`[profile\]`](https://course.rs/cargo/reference/profiles.html) — 编译器设置和优化

- [`[workspace\]`](https://course.rs/cargo/reference/workspaces.html) — 工作空间的定义
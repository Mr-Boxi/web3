# 结构化数据

### 对非结构化json 序列化和反序列化
`serde_json`
```rust
use serde_json::json;
use serde_json::{Value, Error};

fn main() ->Result<(), Error> {
    let j = r#"{
                "userid": 103609,
                "verified": true,
                "access_privileges": [
                "user",
                "admin"
                ]
               }"#;
    let pared: Value = serde_json::from_str(j)?;
    
    let expected = json!({
        "userid": 103609,
        "verified": true,
        "access_privileges": [
            "user",
            "admin"
        ]
    });
    assert_eq!(parsed, expected);
	Ok(())
}
```

### 反序列化toml配置文件

`toml`

将一些 TOML 配置项解析为一个通用的值 `toml::Value`，该值能够表示任何有效的 TOML 数据。

```rust
use toml::{Value, de::Error};

fn main() -> Result<(), Error> {
    let toml_content= r#"
          [package]
          name = "your_package"
          version = "0.1.0"
          authors = ["You! <you@example.org>"]

          [dependencies]
          serde = "1.0""#;
    let package_info: Value = toml::from_str(toml_content)?;
    
    assert_eq!(package_info["dependencies"]["serde"].as_str(), Some("1.0"));
    Ok(())
}
```

将TOML解析为自定义的结构体

```rust
use serde::Deserialize;

use toml::de::Error;
use std::collections::HashMap;

#[derive(Deserizlize)]
struct Config {
    package: Package,
    dependencies: HashMap<String, String>,
}

#[derive(Deserizlize)]
struct Package {
    name: String,
    version: String,
    authors: Vec<String>,
}

fn main() -> Result<(), Error> {
   let toml_content = r#"
          [package]
          name = "your_package"
          version = "0.1.0"
          authors = ["You! <you@example.org>"]

          [dependencies]
          serde = "1.0"
          "#;
    let package_info: Config = toml::from_str(toml_content)?;
    assert_eq!(package_info.package.name, "your_package");
    assert_eq!(package_info.package.version, "0.1.0");
    assert_eq!(package_info.package.authors, vec!["You! <you@example.org>"]);
    assert_eq!(package_info.dependencies["serde"], "1.0")
    
    Ok(())
}
```


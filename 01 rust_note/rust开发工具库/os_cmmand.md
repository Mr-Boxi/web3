# 外部命令



### 运行外部命令并处理 stdout

`git log --oneline` 作为外部命令 [`Command`](https://doc.rust-lang.org/std/process/struct.Command.html) 运行，并使用 [`Regex`](https://docs.rs/regex/*/regex/struct.Regex.html) 检查其 [`Output`](https://doc.rust-lang.org/std/process/struct.Output.html)，以获取最后 5 次提交的哈希值和消息。

```rust
use std::process::Command;
use regex::Regex;

#[derive(PartialEq, Default, Clone, Debug)]
struct Commit {
    hash: String,
    message: String,
}
fn main() -> Resutl<()> {
    let output  = Command::new("git").arg("log").arg("--oneline").output()?;
    
    if !output.status.success() {
        error_chain::bail!("command executed with failing error code");
    }
    
    let pattern = Regex::new(r"(?x)
                               ([0-9a-fA-F]+) # 提交的哈希值
                               (.*)           # 提交信息")?;
    
   String::from_utf8(output.stdout)?
    	.lines()
    	.filter_map(|line| pattern.captures(line))
    	.map(|cap|{
            Commit {
                hash: cap[1].to_string(),
                messsage: cap[2].trim().to_string(),
            }
    	})
    	.take(5)
    	.for_each(|x| println!("{:?}", x));
}
```



### 读取环境变量

```rust
use std::env;
use std::fs;
use std::io::Error;

fn main() -> Result<(), Error> {
    // 从环境变量 CONFIG 读取配置路径 config_path
    // 如果未设置， 采用默认配置
    let config_path = env::var("CONFIG");
    	.unwrap_or("/etc/myapp/config".to_string());
    let config: String = fs::read_to_string(config_path)?;
    println!("config: {}", config);
    Ok(())
}
```


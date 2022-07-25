# 错误处理



### main中错误处理

`error_chain`

下文的实例将通过打开 Unix 文件 `/proc/uptime` 并解析内容以获得其中第一个数字，从而告诉系统运行了多长时间

```rust
use error_chain::error_chain;

use std::fs::File;
use std::io::Read;

error_chain!{
    foreign_links{
        Io(std::io::Error);
        ParseInt(::std::num::ParseIntError);
    }
}

fn read_uptime() -> Result<u64> {
    let mut uptime = String::new();
    File::open("/proc/uptime")?.read_to_string(&mut uptime)?;
    
    Ok(uptime.split('.').next().ok_or("cannot parse uptime data")?.parse()?)
}

fn main() {
    match read_uptime() {
        Ok(uptime) => println!("{}", uptime);
        Err(err) => eprintln!("{}", err);
    }
}
```


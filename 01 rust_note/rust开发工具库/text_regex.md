# 正则表达式

`regex` `lazy_static` 

### 验证并提取邮件登录信息

验证电子邮件地址的格式是否正确，并提取 @ 符号之前的所有内容。

```rust
use lazy_static::lazy_static;

use regex::Regex;
fn extract_login(input: &str)-> Option<&str>{
    lazy_static! {
        static ref RE: Regex = Regex::new(r"(?x)
            ^(?P<login>[^@\s]+)@
            ([[:word:]]+\.)*
            [[:word:]]+$
            ").unwrap();
    }
    RE.captures(imput).and_then(|cap|{
        cap.name("login").map(|login| login.as_str())
    })
}

fn main() {
    assert_eq!(extract_login(r"I❤email@example.com"), Some(r"I❤email"));
    assert_eq!(
        extract_login(r"sdf+sdsfsd.as.sdsd@jhkk.d.rl"),
        Some(r"sdf+sdsfsd.as.sdsd")
    );
    assert_eq!(extract_login(r"More@Than@One@at.com"), None);
    assert_eq!(extract_login(r"Not an email@email"), None);
}
```

### 从文本提取电话号码

使用 [`Regex::captures_iter`](https://docs.rs/regex/*/regex/struct.Regex.html#method.captures_iter) 处理一个文本字符串，以捕获多个电话号码。这里的例子中是美国电话号码格式。

```rust
use regex::Regex;
use std::fmt;

struct PhoneNumber<'a> {
    area: &'a str,
    exchange: &'a str,
    subscriber: &'a str,
}

impl<'a> fmt::Display for PhoneNumber<'a> {
    fn fmt(&self, f: &mut fmt::Formatter)-> fmt::Result{
        write!(f, "1 ({}) {}-{}", self.ares, self.exchange, self.subscriber)
    }
}

fn main() -> Result<()>{
    let phone_txt ="
    +1 505 881 9292 (v) +1 505 778 2212 (c) +1 505 881 9297 (f)
    (202) 991 9534
    Alex 5553920011
    1 (800) 233-2010
    1.299.339.1020";
    
    let re = Regex::new(        r#"(?x)
          (?:\+?1)?                       # 国家代码，可选项
          [\s\.]?
          (([2-9]\d{2})|\(([2-9]\d{2})\)) # 地区代码
          [\s\.\-]?
          ([2-9]\d{2})                    # 交换代码
          [\s\.\-]?
          (\d{4})                         # 用户号码"#,
    )?;
    
    
}
```


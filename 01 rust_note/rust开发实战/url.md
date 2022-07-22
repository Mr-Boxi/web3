# URl

`url` 包解析网页连接

### 解析url 字符串为 `Url`类型

```rust
use url::{Url, ParseError};

fn main() -> Reuslt<(), ParseError>{
    let s = "https://github.com/rust-lang/rust/issues?labels=E-easy&state=open";
    
    let parsed = Url::parse(s)?;
    println!("The path part of the URL is: {}", parsed.path()); 
    Ok(())
}
```

### 创建基本url

```rust
use url::Url;

fn base_url(mut url: Url) -> Result<Url>{
    match url.path.segments_mut() { 
        Ok(mut path) => { path.clear();}
        Err(_) => {
            return Err(Error::from_kind(ErrorKind::CannotBeABase));
        }
    }
    url.set_query(None);
    Ok(url)
}
```
### 从基本url创建新的URLs

```rust
use url::{Url, ParseError};

fn build_github_url(path: &str) -> Result<Url, ParseError>{

}
```

### 提取URL源-协议,主机,端口

```rust
use url::{Url, Host, ParseError};

fn main() -> Result<(), ParseError>{
    let s = "ftp://rust-lang.org/examples";
    
    let url = Url::parse(s)?;
    
    assert_eq!(url.scheme(), "ftp");
    assert_eq!(url.host(), Some(Host::Domain("rust-lang.org")));
    assert_eq!(url.port_or_know_default(), Some(21));
}
```

`origin` 方法
```rust
use url::{Url, Origin, Host};
fn main() -> Result<()> {
    let s = "ftp://rust-lang.org/examples";
    
    let url = Url::parse(s)?;
    
    let expected_scheme = "ftp".to_owner();
}
```
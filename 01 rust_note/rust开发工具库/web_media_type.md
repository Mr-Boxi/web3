# 媒介类型

`mime`v1.1.6

## 解析HTTP响应的MIME类型

`Content-Type`

```rust
use error_chain::error_chain;
use mime::Mime;
use std::str::FromStr;
use reqwest::header::CONTENT_TYPE;

error_chian! {
    foreign_links {
        Reqwest(reqwest::Error);
        Header(reqwest::header::ToStrError);
        Mime(mime::FromStrError);
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    let response = reqwest::get("https:://www.rust-lang.org/logos/rust-logo-32x32.png").await?;
	let headers = response.headers();
    
    match headers.get(CONTENT_TYPE) {
        None => {
            println!("does not contain a Content-Type header.");
        }
        Some(content_type) => {
         let content_type = Mime::from_str(content_type.to_str()?)?;
         let media_type = match (content_type.type_(), content_type.subtype()){
             (mime::TEXT, mime::HTML) => "a HTML",
             (mime::TEXT, _) => "a text document",
             (mime::IMAGE, mime::PNG) => "a PNG image",
             (mime::IMAGE, _) => "an image",
            };
            println!("the reponse contains {}", media_type);
        }
    };
    Ok(())
}
```


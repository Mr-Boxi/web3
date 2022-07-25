# 期间和计算

### 测量运行时间

```rust
use std::time::{Duration, Instant};

fn main() {
    let start = Instant::now();
    
   expensive_function();
    
    let duration = start.elapsed();
    
    println!("{:?}", duration);
}
```



### 日期检查和时间计算

`chrono`

```rust
use chrono::{DataTime, Duration, Utc};

//计算前一天的时间
fn day_earlier(data_time: DateTime<Utc>) -> Option<DateTime<Utc>> {
    date_time.checked_sub_signed(Duration::days(1))
}

fn main() {
    let now = Utc::now();
    println!("{}", now);
    
    
}
```


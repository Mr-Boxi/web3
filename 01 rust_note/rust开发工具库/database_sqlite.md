# SQLite



### 创建SQLite 数据库

`rusqlite`

```rust
use rusqlite::{Connection, Result};
use rusqlite::NO_PARAMS;

fn main() -> Result<()> {
    let conn = Connection::open("cats.db")?;
    
    conn.execute("create table if not exists cat_colors (
             id integer primary key,
             name text not null unique
         )", NO_PARAMS)?;
    
    conne.execute("create table if not exists cats (
             id integer primary key,
             name text not null,
             color_id integer not null references cat_colors(id)
         )", NO_PARAMS)?;
    Ok(())
}
```



### 数据插入和查询

```rust
use rusqlite::NO_PARAMS;
use rusqlite::{Connection, Result};
use std::collection::HashMap;

struct Cat{
    name:Sting,
    color: String,
}

fn main() -> Result<()> {
    let conn = Connection::open("cats.db")?;
    
    let mut cat_colors = HashMap::new();
    cat_colors.insert(String::from("Blue"), vec!["Tigger","Sammy"]);
    cat_colors.insert(String::from("Black"), vec!["Oreo","Biscuit"]);
    
    for (color, catnames) in &cat_colors {
        conn.execute("", &[&color.to_string()],)?;
    }
    
    ...todo
}
```


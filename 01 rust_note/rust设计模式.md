# rust设计模式

资料：http://chuxiuhong.com/chuxiuhong-rust-patterns-zh/intro.html

# 1 rust习惯用法

习惯用法是被社区广泛接受的风格和模式

### 1.1 以借用类型为参数

```
一般地
	使用 &str , 而不是 &String
	使用 &[T] , 而不是 &Vec<T>
	使用 &T   ， 而不是 &Box<T>
```

### 1.2 使用format! 连接字符串

```
// 对一个可变的String类型对象使用push或者push_str方法，或者用+操作符可以构建字符串。
fn say_hello(name: &str) -> String{
	format!("Hello {}", name)
}
// 对一个可变的String类型对象进行一连串的push操作通常是最有效率的（尤其这个字符串已经预先分配了足够的空间）
```


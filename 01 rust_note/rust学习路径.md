# rust 学习路径
rust文档官网：https://rustwiki.org/

1 第一步：通过例子学习rust

2 第二步：rust 程序设计语言

3 rust参考手册：https://rustwiki.org/zh-CN/reference/items/modules.html

4 rust 设计模式

http://chuxiuhong.com/chuxiuhong-rust-patterns-zh/anti_patterns/deny-warnings.html

https://github.com/rust-unofficial/patterns

5 异步编程


# 一本好书，可以看练习
https://course.rs/into-rust.html

# rust 博文

### 迭代器/消费适配器/迭代适配器

- into_iter() // move 
- iter()
- iter_mut()

- map()
- filter

```rust
map 会将迭代项按值传递，因此它传给闭包的是拥有所有权的值，而返回的也是拥有所有权的值
filter 传给闭包的则是迭代项的共享引用，因此如果迭代项的元素类型是&str，那么使用filter(|x| *x !="")时，这个x 是&&str，因此要解引用之后再对比是否等于空
```

1. 迭代器知识

https://blog.csdn.net/guiqulaxi920/article/details/78823541?spm=1001.2101.3001.6650.6&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-6.pc_relevant_aa&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-6.pc_relevant_aa&utm_relevant_index=10



关于内联：https://nihil.cc/posts/translate_rust_inline/

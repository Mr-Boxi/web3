/*
    模块
        模块是在其自身的作用域里执行，并不是在全局作用域，这意味着定义在模块里面的变量、函数和类等在模块外部是不可见的，除非明确地使用 export 导出它们。
        类似地，我们必须通过 import 导入其他模块导出的变量、函数、类等
 */

// 文件 SomeInterface.01 TypeScript
export interface SomeInterface {
    // code
}

// 另一个文件
// import someI = require("./xxx");

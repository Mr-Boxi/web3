/*
    TypeScript 基础数据类型
        - any      任意类型的值
        - number   数字类型
        - string   字符串
        - bool    布尔类型
        - array   数组
        - tuple   元组
        - enum
        - void
        - null
        - undefined
        - never

    note: ts 没有整数类型
 */


// any 类型针对不明确变量定义的数据类型
let x: any = 1;  // 数字类型
x = "i am boix"; // 字符串类型
x = false;       // 布尔类型


// 数字类型
let binaryL: number = 10;
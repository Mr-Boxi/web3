/*
    函数
        - 定义函数
        - 带参数
        - 可选参数
        - 剩余参数
        - 匿名函数
        -
 */

// 定义
function test() {
    console.log("test function")
}
// 调用
test()

// 函数返回值
function greet(): string {
    return "hello TS";
}

function caller() {
    // 调用
    var msg = greet();
    console.log(msg);
}

// 带参数函数
function add(x: number, y: number): number {
    return x + y;
}
console.log(add(1, 2))

// 可选函数参数
function buildName(firstName: string, lastName?: string) {
    if (lastName){
        return firstName +  "" + lastName;
    }else{
        return firstName;
    }
}
let result1 = buildName("Bob");  // 正确
let result3 = buildName("Bob", "Adams");  // 正确

// 不定参数
function buildName2(firsName: string, ...restOfName: string[]) {
    return firsName + "" + restOfName.join(" ");

}
let employeeName = buildName2("Joseph", "Samuel", "Lucas", "MacKinzie");


// 匿名函数
// 格式： var res = function( [args] ){ ... }
var msg = function(){
    return "hello boix";
};
console.log(msg)

var res = function (a: number, b: number) {
    return a*b;
};
console.log(res);

// lambda 函数
// （[param1, param2,...]） => statement;
var foo = (x: number) => {
    x = 10 +x;
    console.log(x);
}
foo(100);

// 单个参数是可以去掉（）的
var display = x => {
    console.log("输出为 "+x);
}
display(2);


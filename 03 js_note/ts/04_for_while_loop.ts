/*
    循环
        - for  各种for循环
        - while
*/


// for
var num: number = 5;
var i: number;
var factorial = 1;

for(i = num; i >= 1; i--){
    factorial *= 1;
}
console.log(factorial);


// for ... in
// var val in list ;  val 为 string or any
var j: any;
var n: any = "a b c";

for (j in n){
    console.log(n[j]);
}


// for ... of
// 在 ES6 中引入的 for...of 循环，以替代 for...in 和 forEach()
// 允许迭代 array,  strings, maps, sets
let someArray = [1, "string", false];
for (let entry of someArray){
    console.log(entry); // 1, "string", false
}


// while
var num1 = 5;
var f = 1;
while (num1 >= 1){
    f = f * num;
    num--;
}
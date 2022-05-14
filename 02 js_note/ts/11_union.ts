/*
    联合类型（重要）
    联合类型（Union Types）可以通过管道(|)将变量设置多种类型，赋值时可以根据设置的类型来赋值。
    注意：只能赋值指定的类型，如果赋值其它类型就会报错。
 */

var val: string | number;
val = 12;
console.log("数字：" + val);

val = "runboo";
console.log("字符串" + val);


// 将 联合类型 作为函数
function disp(name: string | string[]) {
    if( typeof name == "string"){
        console.log(name)
    }else {
        var i;
        for(i = 0; i < name.length;i++ ){
            console.log(name[i]);
        }
    }
}
disp("Runoob");
disp(["Runoob","Google","Taobao","Facebook"])
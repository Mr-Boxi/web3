/*
    数组array
 */

var sites: string[]; //声明
sites = ["googel","runoode","boxi"]; //赋值初始化


// var sites:string[] = new Array("Google","Runoob","Taobao","Facebook")
// 这样也行
var arr_names: number[] = new Array(4);
for (var i = 0; i < arr_names.length; i++){
    arr_names[i] = i * 2;
    console.log(arr_names[i]);
}


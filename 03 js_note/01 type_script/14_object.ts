/*
    对象
       对象是包含一组键值对的实例。 值可以是标量、函数、数组、对象等，如下实例：
 */

var object_name = {
    key1: "value1",
    key2: "value",
    key3: function () {
        //函数
    },
    key4: ["xxx","ttt"] // 集合
}


/*
    类型模板
 */

var sites = {
    site1: "run",
    site2: "goo",
    sayHello: function () {} // 类型模板
}

// @01 TypeScript-ignore
// @ts-ignore
sites.sayHello() = function () {
    console.log("hello " + sites.site1);
};
sites.sayHello();
/*
    类
        字段
        构造函数
        方法
 */
class Car {
    // 字段
    engine: string;

    // 构造函数
    constructor(engine: string) {
        this.engine = engine;
    }

    // 方法
    disp(): void {
        console.log("发动机="+this.engine)
    }
}

// 实例化类
var obj = new Car("Engin 1")


/*
    类的继承
        class child_class_name extends parent_class_name
 */

class Shape {
    Area: number;
    constructor(a: number) {
        this.Area = a;
    }
}

class Circle extends Shape{
    disp(): void {
        console.log("圆的面积:  "+this.Area)
    }
}
var obj1 = new Circle(223);
obj1.disp();
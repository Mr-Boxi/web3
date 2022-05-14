/*
    条件语句
        if else
        switch case
 */

// if else
var num: number = 12;
if (num % 2 == 0) {
    console.log("num 是偶数")
}else{
    console.log("num 是基数")
}


// swithc case
var grade: string = "A";
switch (grade) {
    case "A": {
        console.log("优");
        break;
    }
    case "B": {
        console.log("良");
        break;
    }
    default:{
        console.log("非法输入");
    }
}


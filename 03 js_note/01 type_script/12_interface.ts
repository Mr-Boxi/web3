/*
    接口
        抽象一些列方法
 */

interface IPerson {
    firstName: string,
    lastName: string,
    say: ()=>string
}

var coustomer: IPerson = {
    firstName:"Tom",
    lastName:"Hanks",
    say: ():string =>{return "Hi there"}
}
console.log(coustomer.firstName)
console.log(coustomer.lastName)
console.log(coustomer.say())


/*
    接口继承
    Child_interface_name extends super_interface1_name, super_interface2_name,…,super_interfaceN_name
 */
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// 可以定义结构体
// 在外部定义结构体是可以的， 其他合约是可以导入使用的
contract Todos {
    struct Todo {
        string text;
        bool completed;
    }

    // `todos` 数组
    Todo[] public todos;

    function create(string calldata _text) public{
        // 3 种方式初始化结构体 //
        // -像函数一样调用
        todos.push(Todo(_text, false));

        // - key value mapping
        todos.push(Todo({text: _text, completed: false}));

        // - 初始化一个空的结构体，然后更新值
        Todo memory todo;
        todo.text = _text;
        // todo.completed initialized to false
        todos.push(todo);
    }

    //update text
    function update(uint _index, string calldata _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    // update completd
    function toggleCompleted(uint _index) public {
        Todo storage todo = todos[_index];
        todo.completed = !todo.completed;
    }


}


/*
pragma solidity ^0.8.13;

struct Todo {
    string text;
    bool completed;
}

----------------------------------------
// import

import "./StructDeclaration.sol";

contract Todos {
    // An array of 'Todo' structs
    Todo[] public todos;
}

*/
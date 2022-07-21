// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/**
    keccak256 计算输入数据的 Keccak-256 哈希。

    用例：
     - 从输入创建确定性唯一 ID
     - Commit-Reveal scheme
     - 紧凑的加密签名（ 通过对hash签名 而不是 传入的大数据）
*/
contract HashFuntion{
    function hash(
        string memory _text,
        uint _num,
        address _addr
    )
        public
        pure
        returns(bytes32)
    {
        return keccak256(abi.encodePacked(_text, _num, _addr));
    }


    // 碰撞
    // 使用动态数据对 abi.encodePacked() 进行数据
    // 可能会出现hash 碰撞。
    // 这个例子里应该使用 abi.encode;
    function collision(
        string memory _text, 
        string memory _anotherText
    )
        public
        pure
        returns(bytes32)
    {
        // encodePacked(AAA, BBB) -> AAABBB
        // encodePacked(AA, ABBB) -> AAABBB
        return keccak256(abi.encodePacked(_text, _anotherText));
    }

}


contract GuessTheMagicWord {
    bytes32 public answer = 0x60298f78cc0b47170ba79c10aa3851d7648bd96f2f8e46a19dbc777c36fb0c00;

    // Magic word is "Solidity"
    function guess(string memory _word) public view returns (bool) {
        return keccak256(abi.encodePacked(_word)) == answer;
    }

}

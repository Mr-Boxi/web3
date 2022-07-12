// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
  重入漏洞
        合约A  调用 合约B
        可重入漏洞就是允许B 在A未执行完成之前回调A。
*/

/*
*/

contract EtherStore{
    mapping(address => uint) public balances;

    function deposti() public payable{
      balances[msg.sender] += msg.value;
    }

    function withdraw() public {
      uint bal = balances[msg.sender];
      require(bal > 0);
      (bool sent, ) = msg.sender.call{value: bal}("");
      require(sent, "Failed to send Ether");
      balances[msg.sender] = 0;
    }
    
    function getBalance() public view returns (uint){
      return address(this).balance;
    }
}

contract Attack{
  EtherStore public etherStore;

  constructor(address _etherStoreAddress) {
    etherStore = EtherStore(_etherStoreAddress);
  }  
}
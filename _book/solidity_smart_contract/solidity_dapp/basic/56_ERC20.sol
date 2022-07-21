// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interferce IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function transfer(address, uint) external returns(bool);
    function transferFrom(address ,address, uint) external returns (bool);
    function allowance(address, address) external view returns (uint);
    function approve(address, uint) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract ERC20 is IERC20 {
    function totalSupply() external view returns (uint){
        return totalSupply_();
    }
    function balanceOf(address) external view returns (uint);
    function transfer(address, uint) external returns(bool);
    function transferFrom(address ,address, uint) external returns (bool);
    function allowance(address, address) external view returns (uint);
    function approve(address, uint) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}
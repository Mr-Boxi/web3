// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/**
    导入本地文件 or  外部文件
    
    local
     |- import.sol
     |- Foo.so
 */

 /**
 foo.sol

struct Point{
    uint x;
    uint y;
}

error Unauthorized(address caller);

function add(uint x, uint y) pure returns (uint){
    return x + y;
} 

contract Foo {
    string public name = "Foo";
}

*/


/////////////////////////////////////////
//  
////////////////////////////////////////
/**
import.sol

import "./Foo.sol";

// import {symbol1 as alias, symbol2} from "filename";
import {Unauthorized, add as func, Point} from "./Foo.sol"


contract Import {
    // Initialize Foo.sol
    Foo public foo = new Foo();

    // Test Foo.sol by getting it's name.
    function getFooName() public view returns (string memory) {
        return foo.name();
    }

}
 */


/////////////////////////////////////////
//             external  
////////////////////////////////////////
/**

// 导入github 

// https://github.com/owner/repo/blob/branch/path/to/Contract.sol
import "https://github.com/owner/repo/blob/branch/path/to/Contract.sol";

// Example import ECDSA.sol from openzeppelin-contract repo, release-v4.5 branch
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/utils/cryptography/ECDSA.sol
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/utils/cryptography/ECDSA.sol";
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


// for, while, do whild
// 因为gas 的原因， while, do whild 是很少使用的
contract Loop{
    function loop() public pure {
        // for loop
        for (uint i = 0; i < 10; i++) {
            if ( i == 3){
                continue;
            }
            if (i == 5) {
                break;
            }
        }

        // while loop
        uint j;
        while (j < 10) {
            j++;
        }
    }
}
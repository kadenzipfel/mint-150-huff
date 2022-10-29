pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {NotRareToken, OptimizedAttacker} from "../src/Mint150.sol";

contract Mint150Test is Test {
    NotRareToken nrt;

    function setUp() external {
        nrt = new NotRareToken();
    }

    function testNrtMint() external {
        nrt.mint();
    }
}
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {NotRareToken, OptimizedAttacker} from "../src/Mint150.sol";

contract Mint150Test is Test {
    NotRareToken nrt;
    uint256 constant PREMINTS = 5;

    function setUp() external {
        nrt = new NotRareToken();
        for (uint256 i; i < PREMINTS; ++i) {
            vm.prank(address(1));
            nrt.mint();
        }
    }

    function testMint150() external {
        vm.prank(address(0xBEEF));
        new OptimizedAttacker(address(nrt));

        uint256 balance = nrt.balanceOf(address(0xBEEF));
        assertEq(balance, 150);
    }
}
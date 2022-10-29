pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {HuffConfig} from "foundry-huff/HuffConfig.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";
import {NotRareToken, OptimizedAttacker} from "../src/Mint150.sol";

interface Mint150 {
    function getVictim() view external returns (address);
}

contract Mint150HuffTest is Test {
    NotRareToken nrt;
    Mint150 mint150;
    uint256 constant PREMINTS = 5;

    function setUp() external {
        nrt = new NotRareToken();
        for (uint256 i; i < PREMINTS; ++i) {
            vm.prank(address(1));
            nrt.mint();
        }
    }

    function testMint150() external {
        HuffConfig config = HuffDeployer.config()
            .with_args(abi.encode(address(nrt)));
        mint150 = Mint150(config.deploy('../src/Mint150'));

        uint256 balance = nrt.balanceOf(address(0x0C7BBB021d72dB4FfBa37bDF4ef055eECdbc0a29));
        assertEq(balance, 150);
    }
}
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
    uint256 constant PREMINTS = 5;

    function setUp() external {
        nrt = new NotRareToken();
        for (uint256 i; i < PREMINTS; ++i) {
            vm.prank(address(1));
            nrt.mint();
        }
    }

    function testGetVictim() external {
        string memory wrapper_code = vm.readFile("test/Mint150Wrapper.huff");
        HuffConfig config = HuffDeployer.config()
            .with_code(wrapper_code)
            .with_args(abi.encode(address(nrt)));
        vm.prank(address(0xBEEF));
        Mint150 mint150 = Mint150(config.deploy('../src/Mint150'));

        address victim = Mint150(mint150).getVictim();
    }

    // function testMint150() external {
    //     vm.prank(address(0xBEEF));
    //     HuffDeployer
    //         .config()
    //         .with_args(abi.encode(address(nrt)))
    //         .deploy('../src/Mint150');

    //     uint256 balance = nrt.balanceOf(address(0xBEEF));
    //     assertEq(balance, 150);
    // }
}
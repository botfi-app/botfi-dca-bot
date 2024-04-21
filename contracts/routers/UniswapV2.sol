/**
 * SPDX-License-Identifier: MIT
 * BotFi DCA bot Smart  contracts
 * @uthor BotFi Team <hello@botfi.app>
 */
pragma solidity ^0.8.20;

import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract UniswapV2 is ReentrancyGuard {

    function swap(
        address tokenA,
        address tokenB,
        uint256 amount
    )
        external
        nonReentrant()
        returns (uint256)
    {
        
    }
}
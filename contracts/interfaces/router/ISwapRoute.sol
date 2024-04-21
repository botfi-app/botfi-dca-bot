/**
 * SPDX-License-Identifier: MIT
 * BotFi DCA bot Smart  contracts
 * @uthor BotFi Team <hello@botfi.app>
 */
pragma solidity ^0.8.20;

interface ISwapRouter {

    function swap(
        address tokenA,
        address tokenB,
        uint256 amount
    ) external;
}
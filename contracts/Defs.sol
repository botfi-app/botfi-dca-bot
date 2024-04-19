/**
 * SPDX-License-Identifier: MIT
 * BotFi DCA bot Smart  contracts
 * @uthor BotFi Team <hello@botfi.app>
 */
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";

contract Defs is Context, ReentrancyGuard {

    bytes32 ORDER_TYPE_BUY = bytes32("ORDER_TYPE_BUY");
    bytes32 ORDER_TYPE_SELL = bytes32("ORDER_TYPE_SELL");
    bytes32 TRIGGER_BY_PRICE_ACTION = bytes32("TRIGGER_BY_PRICE_ACTION");
    bytes32 TRIGGER_BY_TIME_ACTION = bytes32("TRIGGER_BY_TIME_ACTION");
    
    struct JobDef {
        bytes32 orderType;
        bytes32 triggerBy;
        address tokenA;
        address tokenB;
        address owner;
        uint256 tokenABalance;
        uint256 tokenASold;
        uint    tokenBBuyRatePerTx;
    }
} 
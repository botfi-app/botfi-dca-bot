/**
 * SPDX-License-Identifier: MIT
 * BotFi DCA bot Smart  contracts
 * @uthor BotFi Team <hello@botfi.app>
 */
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";

contract Base is Context, ReentrancyGuard {

    address constant NATIVE_TOKEN = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;

    uint256 public totalJobs;
    uint256 public totalActiveJobs;

    bytes32 ORDER_TYPE_BUY = bytes32("ORDER_TYPE_BUY");
    bytes32 ORDER_TYPE_SELL = bytes32("ORDER_TYPE_SELL");
    bytes32 TRIGGER_BY_PRICE_ACTION = bytes32("TRIGGER_BY_PRICE_ACTION");
    bytes32 TRIGGER_BY_TIME_ACTION = bytes32("TRIGGER_BY_TIME_ACTION");
    
    struct Job {
        uint256 id;
        bytes32 orderType;
        bytes32 triggerBy;
        bytes32 route;
        address tokenA;
        address tokenB;
        address owner;
        uint256 tokenABalance;
        uint256 totalTokenASold;
        uint    tokenASellRatePerTx;
        bool    isActive;
        uint256 createdAt;
        uint256 updatedAt;
    }

    mapping(uint256 => Job) public jobs;
    mapping(address => uint256[]) public jobsByAccount;
    uint256[] public activeJobsIds;
} 
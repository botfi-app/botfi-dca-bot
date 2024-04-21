/**
 * SPDX-License-Identifier: MIT
 * BotFi DCA bot Smart  contracts
 * @uthor BotFi Team <hello@botfi.app>
 */
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Base is Context, ReentrancyGuard {


    bool public isPaused = false;

    address constant NATIVE_TOKEN = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;

    uint256 public totalJobs;
    uint256 public totalActiveJobs;

    bytes32 TRIGGER_MODE_PRICE_UP    = bytes32("TRIGGER_MODE_PRICE_UP");
    bytes32 TRIGGER_MODE_PRICE_DOWN  = bytes32("TRIGGER_MODE_PRICE_DOWN");
    bytes32 TRIGGER_MODE_TIME_ACTION = bytes32("TRIGGER_BY_TIME_ACTION");

    struct TriggerInfo {
        bytes32 mode;
        uint256 runAfter;
        uint256 lastRunDate;
    }

    struct TokenInfo {
        address tokenA;
        address tokenB;
        uint256 tokenAStartBalance;
        uint256 tokenACurrentBalance;
        uint256 tokenASellRatePerTx;
    }
    
    struct Job {
        uint256 id;
        TriggerInfo  triggerInfo;
        TokenInfo    tokenInfo;
        address      owner;
        bytes32      routeUsed;
        bool         isActive;
        uint256      createdAt;
    }

    mapping(uint256 => Job) public jobs;
    mapping(address => uint256[]) public jobsByAccount;
    uint256[] public activeJobsIds;
    
    function safeTransferNative(address payable to, uint256 value) internal {
        (bool success, ) = to.call{value: value}("");
        require(success, 'DCABot: NATIVE_TOKEN_TRANSFER_FAILED');
    }


    function safeTransferToken(
        address token,
        address to,
        uint256 amount
    )
        internal 
    {
        if(token == NATIVE_TOKEN){
            safeTransferNative(payable(to), amount);
        } else {
            require(IERC20(token).transfer(to, amount), "DCABot: ERC20_TOKEN_TRANSFER_FAILED");
        }
    }

    function calPercent(uint256 percentBps, uint256 amount)
        internal 
        pure
        returns (uint256)
    {
        return (percentBps * amount) / 10_000;
    }
} 
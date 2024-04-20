/**
 * SPDX-License-Identifier: MIT
 * BotFi DCA bot Smart  contracts
 * @uthor BotFi Team <hello@botfi.app>
 */
pragma solidity ^0.8.20;

import "./Base.sol";

contract Factory is Ownable, Base {

    address payable protocolFeeWallet;

    constructor(address payable _feeWallet) Ownable(_msgSender()) {
        protocolFeeWallet = _feeWallet;
    }
    
    /**
     * @dev fetch active job ids
     * @param fromIndex the index to start from
     * @param toIndex the index to end
     */
    function getActiveJobsIds(uint256 fromIndex, uint256 toIndex)
        external
        view
        returns (uint256[] memory resultArr)
    {
        uint endIdx = toIndex;

        if(toIndex > activeJobsIds.length){
            endIdx = activeJobsIds.length;
        }

        resultArr = new uint256[](endIdx);

        for(uint i = fromIndex; i >= endIdx; i++){
            resultArr[i] = activeJobsIds[i];
        }
    }


    function setPaused(bool _opt)
        public
        onlyOwner()
    {
        isPaused = _opt;
    }

    modifier notPaused(){
        require(!isPaused, "DCABot: PAUSED");
        _;
    }

    /**
     * @dev addJob adds a new job
     */
    function addJob(
        address tokenA,
        address tokenB,
        uint256 amount,
        uint256 tokenASellRatePerTx,
        bytes32 triggerMode,
        uint256 triggerAfterEvery
    )
        external
        payable
        nonReentrant()
        notPaused()
    {
        
        if(tokenA == NATIVE_TOKEN){
            require(amount == msg.value, "DCABot: AMOUNT_AND_VALUE_MISMATCH");
        } else {
            require(IERC20(tokenA).transferFrom(_msgSender(), address(this), amount), "DCABot: TRANSFER_FAILED");
        }

        uint256 id = ++totalJobs;

        jobs[id] = Job(
            id,
            triggerMode,
            triggerAfterEvery,
            tokenA,
            tokenB,
            _msgSender(),
            amount, // tokenABalance
            0, //totalTokenASold
            tokenASellRatePerTx,
            "", // routeUsed
            true,
            block.timestamp,
            block.timestamp
        );
    }

   
}
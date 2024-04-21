/**
 * SPDX-License-Identifier: MIT
 * BotFi DCA bot Smart  contracts
 * @uthor BotFi Team <hello@botfi.app>
 */
pragma solidity ^0.8.20;

import "./Base.sol";

contract Factory is Ownable, Base {

    event NewJob(uint256 id);
    event CancelJob(uint256 id);

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
     * @dev newJob adds a new job
     */
    function newJob(
        address tokenA,
        address tokenB,
        uint256 amount,
        uint256 tokenASellRatePerTx,
        bytes32 triggerMode,
        uint256 runAfterEvery
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
            TriggerInfo(triggerMode, runAfterEvery, 0),
            TokenInfo(tokenA, tokenB, amount, amount, tokenASellRatePerTx),
            _msgSender(),
            "", // routeUsed
            true, // isActive
            block.timestamp
        );

        jobsByAccount[_msgSender()].push(id);
        activeJobsIds[id] = id;

        emit NewJob(id);
    }

    /**
     * @dev cancels or disables a job
     * @param id a unit256 id of the job
     */
    function cancelJob(uint256 id)
        public
        nonReentrant()
    {
        
        require(jobs[id].owner == _msgSender(), "DCABot: NOT_JOB_OWNER");
        require(jobs[id].isActive, "DCABot: JOB_NOT_ACTIVE");

        uint256 remainingBalance = jobs[id].tokenInfo.tokenACurrentBalance;

        if(remainingBalance > 0){
            safeTransferToken(jobs[id].tokenInfo.tokenA, jobs[id].owner, remainingBalance);
        }

        jobs[id].tokenInfo.tokenACurrentBalance = 0;
        jobs[id].isActive = false;

        emit CancelJob(id);
    }

}
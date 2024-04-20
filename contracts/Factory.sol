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

    
}
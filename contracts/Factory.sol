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
    
    
}
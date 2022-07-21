// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract CryptoCupToken is ERC20 {
    
    // Tokenomics
    uint256 private _seedSupply = 0 * 1e18; // 5% => $0.09 => 20% TGE => 20% Monthly Vesting
    uint256 private _privateSaleSupply = 0 * 1e18; // 15% => $0.11 => 20% TGE => 20% Monthly Vesting
    uint256 private _publicSaleSupply = 0 * 1e18; // 15% => $0.14 => 100% TGE
    uint256 private _teamSupply = 0 * 1e18; // 10% => 10% TGE => 10% Monthly
    uint256 private _advisorsSupply = 0 * 1e18; // 5% => 10% TGE => 10% Monthly
    uint256 private _marketingSupply = 0 * 1e18; // 0%
    uint256 private _reserveSupply = 0 * 1e18; // 0%
    uint256 private _stakingSupply = 0 * 1e18; // 0%
    uint256 private _rewardsSupply = 0 * 1e18; // 0%

    // Initial Token Supply
    uint256 private _initialSupply = _seedSupply + _privateSaleSupply + _publicSaleSupply + _teamSupply + _advisorsSupply + _marketingSupply + _reserveSupply + _stakingSupply + _rewardsSupply;

    constructor() ERC20("Cryptocup Token", "CCT") {
        _mint(msg.sender, _initialSupply);
    }

}
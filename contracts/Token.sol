// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract CryptoCupToken is ERC20 {
    
    // Tokenomics
    uint256 private _ownersSupply = 0 * 1e18; // 0%
    uint256 private _seedSupply = 0 * 1e18; // 0%
    uint256 private _privateSaleSupply = 0 * 1e18; // 0%
    uint256 private _publicSaleSupply = 0 * 1e18; // 0%
    uint256 private _liquiditySupply = 0 * 1e18; // 0%
    uint256 private _teamSupply = 0 * 1e18; // 0%
    uint256 private _advisorsSupply = 0 * 1e18; // 0%
    uint256 private _marketingSupply = 0 * 1e18; // 0%
    uint256 private _reserveSupply = 0 * 1e18; // 0%
    uint256 private _stakingSupply = 0 * 1e18; // 0%
    uint256 private _ecosystemSupply = 0 * 1e18; // 0%
    uint256 private _airdropSupply = 0 * 1e18; // 0%
    uint256 private _rewardsSupply = 0 * 1e18; // 0%

    // Initial Token Supply
    uint256 private _initialSupply = _ownersSupply + _seedSupply + _privateSaleSupply + _publicSaleSupply + _liquiditySupply + _teamSupply + _advisorsSupply + _marketingSupply + _reserveSupply + _stakingSupply + _ecosystemSupply + _airdropSupply + _rewardsSupply;

    constructor() ERC20("Cryptocup Token", "CCT") {
        _mint(msg.sender, _initialSupply);
    }

}
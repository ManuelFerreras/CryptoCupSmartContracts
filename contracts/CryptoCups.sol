// SPDX-License-Identifier: MIT


/**
 * CryptoCup Smart Contracts
 *
 * Developed By:
 *    - Manuel (NuMa) Ferreras
 *    - Agustin ...
 *
 */


pragma solidity ^0.8.4;

import './ERC721A.sol';
import './Ownable.sol';

contract CryptoCupsTickets is ERC721A, Ownable {

    // Ticket Type
    mapping (uint => string) public ticketType; 

    // Ticket Types
    string[] private ticketTypes = ["Basic", "Boost"]; 

    // Prices in USD
    uint[] public prices = [15, 40]; 

    // Different Currencies Accepted
    address[] public currencies = [
        0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063, // DAI Matic
        0xA8D394fE7380b8cE6145d5f85E6aC22d4E91ACDe, // BUSD Matic
        0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174, // USDC Matic
        0xc2132D05D31c914a87C6611C10748AEb04B58e8F // USDT Matic
    ];


    // Constructor
    constructor(string memory name_, string memory symbol_) ERC721A (name_, symbol_) {}


    // Events
    event currencyAdded(address);
    event priceChanged(string, uint);
    event newTicketType(string, uint);


    // Functions
    function mint(uint _amount, uint _currency, uint _type) public {
        // Check if Params Are Correct
        require(_amount > 0, "Invalid Amount.");
        require(_currency >= 0 && _currency < currencies.length, "Invalid Currency.");
        require(_type >= 0 && _type < ticketTypes.length, "Invalid Type.");

        // Checks msg.sender has enough balance.
        IERC20Metadata _selectedCurrency = IERC20Metadata(currencies[_currency]);
        uint _totalPriceAmount = _amount * prices[_type] * _selectedCurrency.decimals();
        require(_selectedCurrency.balanceOf(msg.sender) >= prices[_type], "Not Enough Balance to Pay.");
        require(_selectedCurrency.allowance(msg.sender, address(this)) >= prices[_type], "Not Enough Balance to Pay.");

        // Pay for the ticket.
        _selectedCurrency.transferFrom(msg.sender, address(this), _totalPriceAmount);

        // Mint the Tickets!
        _mint(msg.sender, _amount);
    }   


    function addCurrency(address _newCurrency) public onlyOwner {
        currencies.push(_newCurrency);
        emit currencyAdded(_newCurrency);
    }


    function changePrice(uint _type, uint _amount) public onlyOwner {
        require(_type >= 0 && _type < prices.length, "Invalid type.");
        require(_amount != 0, "Invalid Price");

        prices[_type] = _amount; 
        emit priceChanged(ticketTypes[_type], _amount);
    }


    function addTicketType(string memory _name, uint _value) public onlyOwner {
        require(keccak256(abi.encodePacked(_name)) != keccak256(abi.encodePacked("")), "Invalid Name");
        require(_value > 0, "Invalid value");

        ticketTypes.push(_name);
        prices.push(_value);
        emit newTicketType(_name, _value);
    }

}
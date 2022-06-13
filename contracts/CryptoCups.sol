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
        require(_selectedCurrency.allowance(msg.sender, address(this)) >= prices[_type], "Not Enough Allowance to Pay.");

        // Pay for the ticket.
        _selectedCurrency.transferFrom(msg.sender, address(this), _totalPriceAmount);

        // Mint the Tickets!
        _mint(msg.sender, _amount, _type);
    }   


    /**
     * @dev Mints `quantity` tokens and transfers them to `to`.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `quantity` must be greater than 0.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 quantity, uint256 _type) internal {
        uint256 startTokenId = _currentIndex;
        if (to == address(0)) revert MintToZeroAddress();
        if (quantity == 0) revert MintZeroQuantity();

        _beforeTokenTransfers(address(0), to, startTokenId, quantity);

        // Overflows are incredibly unrealistic.
        // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
        // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
        unchecked {
            _addressData[to].balance += uint64(quantity);
            _addressData[to].numberMinted += uint64(quantity);

            _ownerships[startTokenId].addr = to;
            _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);

            uint256 updatedIndex = startTokenId;
            uint256 end = updatedIndex + quantity;

            do {
                ticketType[updatedIndex] = ticketTypes[_type];
                emit Transfer(address(0), to, updatedIndex++);
            } while (updatedIndex < end);

            _currentIndex = updatedIndex;
        }
        _afterTokenTransfers(address(0), to, startTokenId, quantity);
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

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        string memory baseURI = _baseURI();
        return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, ticketType[tokenId], ".json")) : '';
    }

}
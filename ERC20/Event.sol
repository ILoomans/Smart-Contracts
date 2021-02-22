pragma solidity ^0.5.11;

import "./ERC20.sol";

contract Event {
    struct type2 {
        string typeName;
        string symbol;
        uint256 totalSupply;
        uint256 price;
    }

    address public owner;

    mapping(address => type2) types;
    address[] public tAddresses;

    constructor(
        uint256 _totalSupply,
        string memory _typeName,
        string memory _symbol,
        uint256 _price,
        address _sender
    ) public {
        address c =
            address(
                new ERC20(_totalSupply, _typeName, _symbol, 0, _price)
            );
        types[c].totalSupply = _totalSupply;
        types[c].typeName = _typeName;
        types[c].symbol = _symbol;
        types[c].price = _price;
        tAddresses.push(c);
        owner = _sender;
    }

    function addContract(
        uint256 _totalSupply,
        string memory _typeName,
        string memory _symbol,
        uint256 _decimals,
        uint256 _price
    ) public {
        require(msg.sender == owner, "You are not authorized to add tokens!");
        address c =
            address(
                new ERC20(_totalSupply, _typeName, _symbol, _decimals, _price)
            );
        types[c].totalSupply = _totalSupply;
        types[c].typeName = _typeName;
        types[c].symbol = _symbol;
        types[c].price = _price;
        tAddresses.push(c);
    }

    function getName(address caddress) public view returns (string memory) {
        return types[caddress].typeName;
    }

    function getSymbol(address caddress) public view returns (string memory) {
        return types[caddress].symbol;
    }

    function getSupply(address caddress) public view returns (uint256) {
        return types[caddress].totalSupply;
    }

    function getPrice(address caddress) public view returns (uint256) {
        return types[caddress].price;
    }

    function getArray() public view returns (address[] memory) {
        return tAddresses;
    }
}

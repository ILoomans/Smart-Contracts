pragma solidity ^0.5.11;

import "./ERC20.sol";
import "./Event.sol";

contract Host {
    struct info {
        string eventName;
        string location;
        uint256 date;
        address owner;
    }

    mapping(address => info) Events;
    address[] public eAddresses;

    mapping(address => address[]) public Owners;

    function createEvent(
        string memory _eventName,
        string memory _location,
        uint256 _date,
        uint256 _totalSupply,
        string memory _tokenName,
        string memory _symbol,
        uint256 _price
    ) public {
        address sender = msg.sender;
        address c =
            address(
                new Event(
                    _totalSupply,
                    _tokenName,
                    _symbol,
                    0,
                    _price,
                    sender
                )
            );
        Events[c].eventName = _eventName;
        Events[c].location = _location;
        Events[c].date = _date;
        Events[c].owner = msg.sender;
        eAddresses.push(c);

        Owners[msg.sender].push(address(c));
    }

    function getEvents(address oaddress)
        public
        view
        returns (address[] memory)
    {
        return Owners[oaddress];
    }

    function getName(address caddress) public view returns (string memory) {
        return Events[caddress].eventName;
    }

    function getLocation(address caddress) public view returns (string memory) {
        return Events[caddress].location;
    }

    function getDate(address caddress) public view returns (uint256) {
        return Events[caddress].date;
    }

    function getArray() public view returns (address[] memory) {
        return eAddresses;
    }
}

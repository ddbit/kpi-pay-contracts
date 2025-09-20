// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Performance {
    address public owner;
    mapping(bytes32 => uint256) public Indicator;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setOwner(address _owner) external onlyOwner {
        owner = _owner;
    }

    function set(bytes32 key, uint256 indicator) external onlyOwner {
        Indicator[key] = indicator;
    }
}
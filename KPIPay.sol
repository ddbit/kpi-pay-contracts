// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
}

interface IPerformance {
    function Indicator(bytes32 key) external view returns (uint256);
}

contract KPIPay {
    address public sender;
    address public receiver;
    address public tokenContract;
    uint256 public benchmark;
    uint256 public timeout;
    uint256 public time0;
    bytes32 public key;
    IPerformance public performance;

    constructor(
        address _sender,
        address _receiver,
        address _tokenContract,
        uint256 _benchmark,
        uint256 _timeout,
        address _performance,
        bytes32 _key
    ) {
        sender = _sender;
        receiver = _receiver;
        tokenContract = _tokenContract;
        benchmark = _benchmark;
        timeout = _timeout;
        performance = IPerformance(_performance);
        key = _key;
        time0 = block.timestamp;
    }

    function pay() external {
        uint256 indicator = performance.Indicator(key);
        uint256 bal = IERC20(tokenContract).balanceOf(address(this));
        require(bal > 0, "zero balance");
        
        if (indicator >= benchmark) {
            require(IERC20(tokenContract).transfer(receiver, bal), "transfer failed");
        } else {
            require(block.timestamp > time0 + timeout, "timeout not reached");
            require(IERC20(tokenContract).transfer(sender, bal), "transfer failed");
        }
    }
}

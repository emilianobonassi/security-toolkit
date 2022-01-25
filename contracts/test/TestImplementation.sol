// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.11;

import "../Security3.sol";

contract TestImplementation is Security3 {
    event TestEvent();

    constructor(
        address _governance,
        address _operator,
        address payable _emergencyImplementation
    ) Security3(_governance, _operator, _emergencyImplementation) {}

    function functionToReplace() external whenPausedthenProxy {
        emit TestEvent();
    }
}

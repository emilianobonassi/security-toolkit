// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.11;

import "../Security4.sol";

contract TestSecurity4 is Security4 {
    event TestEvent();

    constructor(
        address _governance,
        address _operator,
        address payable _emergencyImplementation
    ) Security4(_governance, _operator, _emergencyImplementation) {}

    function functionToReplace() external onlyAllowlisted whenPausedthenProxy {
        emit TestEvent();
    }
}

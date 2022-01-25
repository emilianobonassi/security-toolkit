// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.11;

contract TestEmergencyImplementation {
    event TestEmergencyEvent();

    function functionToReplace() external {
        emit TestEmergencyEvent();
    }
}

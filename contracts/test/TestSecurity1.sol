// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "../Security1.sol";

/**
 * Ensure that any contracts that inherits from this has level 1 of security (payable)
 */
contract TestSecurity1 is Security1 {
    constructor(address _governance, address _operator)
        Security1(_governance, _operator)
    {}

    receive() external payable {}
}

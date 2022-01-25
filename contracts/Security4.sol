// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

/**
 * Ensure that any contracts that inherits from this has level 4 of security
 */

import "./utils/Allowlistable.sol";

import "./Security3.sol";

contract Security4 is Security3, Allowlistable {
    constructor(
        address _governance,
        address _operator,
        address payable _emergencyImplementation
    ) Security3(_governance, _operator, _emergencyImplementation) {}

    function enableAllowlist() public virtual override onlyGovernance {
        super.enableAllowlist();
    }

    function disableAllowlist() public virtual override onlyGovernance {
        super.disableAllowlist();
    }

    function allow(address[] calldata users)
        public
        virtual
        override
        onlyOperatorOrGovernance
    {
        super.allow(users);
    }

    function disallow(address[] calldata users)
        public
        virtual
        override
        onlyGovernance
    {
        super.disallow(users);
    }
}

// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

/**
 * Ensure that any contracts that inherits from this has level 3 of security
 */

import "./Security2.sol";

contract Security3 is Security2 {
    address payable public emergencyImplementation;

    modifier whenPausedthenProxy() {
        if (paused()) {
            thenProxy();
        } else {
            _;
        }
    }

    constructor(
        address _governance,
        address _operator,
        address payable _emergencyImplementation
    ) Security2(_governance, _operator) {
        require(
            _emergencyImplementation != address(0),
            "Emergency implementation cannot be null"
        );
        emergencyImplementation = _emergencyImplementation;
    }

    /**
     * @dev Set emergency implementation
     * @param _emergencyImplementation emergency implementation address.
     */
    function setEmergencyImplementation(
        address payable _emergencyImplementation
    ) public virtual onlyGovernance {
        emergencyImplementation = _emergencyImplementation;
    }

    function thenProxy() internal virtual {
        address payable _emergencyImplementation = emergencyImplementation;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            let free_ptr := mload(0x40)
            calldatacopy(free_ptr, 0, calldatasize())

            let result := delegatecall(
                gas(),
                _emergencyImplementation,
                free_ptr,
                calldatasize(),
                0,
                0
            )
            returndatacopy(free_ptr, 0, returndatasize())

            if iszero(result) {
                revert(free_ptr, returndatasize())
            }
            return(free_ptr, returndatasize())
        }
    }
}

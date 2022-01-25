// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

/**
 * Ensure that any contracts that inherits from this has level 2 of security
 */

import "./Security1.sol";

contract Security2 is Security1 {
    constructor(address _governance, address _operator)
        Security1(_governance, _operator)
    {}

    /**
     * @dev Executy any tx in emergency (only governance)
     */
    function emergencyExecute(
        address to,
        uint256 value,
        bytes memory data,
        bool isDelegateCall,
        uint256 txGas
    ) public payable virtual whenPaused onlyGovernance {
        bool success;

        if (isDelegateCall) {
            // solhint-disable-next-line no-inline-assembly
            assembly {
                success := delegatecall(
                    txGas,
                    to,
                    add(data, 0x20),
                    mload(data),
                    0,
                    0
                )
            }
        } else {
            // solhint-disable-next-line no-inline-assembly
            assembly {
                success := call(
                    txGas,
                    to,
                    value,
                    add(data, 0x20),
                    mload(data),
                    0,
                    0
                )
            }
        }

        require(success, "failed execution");
    }
}

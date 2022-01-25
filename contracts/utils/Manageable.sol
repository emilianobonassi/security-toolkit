// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

/**
 * Simple two-roles contract, governance and operator
 * Operator can be changed only by governance
 * Governance update needs acceptance
 */

contract Manageable {
    //TODO events

    address public pendingGovernance;
    address public governance;
    address public operator;

    modifier onlyGovernance() {
        require(msg.sender == governance, "Only Governance");
        _;
    }

    modifier onlyOperatorOrGovernance() {
        require(
            msg.sender == operator || msg.sender == governance,
            "Only Operator or Governance"
        );
        _;
    }

    constructor(address _governance, address _operator) {
        governance = _governance;
        operator = _operator;
    }

    /**
     * @dev Set operator
     * @param _operator operator address.
     */
    function setOperator(address _operator) public virtual onlyGovernance {
        operator = _operator;
    }

    /**
     * @dev Set new governance
     * @param _governance governance address.
     */
    function setGovernance(address _governance) public virtual onlyGovernance {
        pendingGovernance = _governance;
    }

    /**
     * @dev Accept proposed governance
     */
    function acceptGovernance() public virtual {
        require(msg.sender == pendingGovernance, "Only Proposed Governance");

        governance = pendingGovernance;
        pendingGovernance = address(0);
    }
}

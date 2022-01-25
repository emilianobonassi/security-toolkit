// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

/**
 * Simple allowlist mechanism
 */

contract Allowlistable {
    bool public allowlistEnabled;

    mapping(address => bool) public allowlist;

    modifier onlyAllowlisted() {
        require(
            !allowlistEnabled || _isAllowlisted(msg.sender),
            "User not allowed"
        );
        _;
    }

    function enableAllowlist() public virtual {
        allowlistEnabled = true;
    }

    function disableAllowlist() public virtual {
        allowlistEnabled = false;
    }

    function allow(address[] calldata users) public virtual {
        for (uint256 i = 0; i < users.length; i++) {
            allowlist[users[i]] = true;
        }
    }

    function disallow(address[] calldata users) public virtual {
        for (uint256 i = 0; i < users.length; i++) {
            allowlist[users[i]] = false;
        }
    }

    function _isAllowlisted(address user) internal virtual returns (bool) {
        return allowlist[user];
    }
}

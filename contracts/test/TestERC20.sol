// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestERC20 is ERC20 {
    constructor() ERC20("TestERC20", "TERC20") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TestERC721 is ERC721 {
    constructor() ERC721("TestERC721", "TERC721") {}

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}

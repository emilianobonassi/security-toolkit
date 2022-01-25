// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
    Ensures that any contract that inherits from this contract is able to
    withdraw funds that are accidentally received or stuck.
 */

contract Withdrawable {
    using SafeERC20 for IERC20;
    address constant ETHER = address(0);

    event LogWithdraw(
        address indexed _from,
        address indexed _assetAddress,
        uint256 indexed tokenId,
        uint256 amount
    );

    /**
     * @dev Withdraw asset ERC20 or ETH
     * @param _assetAddress Asset to be withdrawn.
     */
    function _withdrawERC20ETH(address _assetAddress) internal virtual {
        uint256 assetBalance;
        if (_assetAddress == ETHER) {
            address self = address(this); // workaround for a possible solidity bug
            assetBalance = self.balance;
            payable(msg.sender).transfer(assetBalance);
        } else {
            assetBalance = IERC20(_assetAddress).balanceOf(address(this));
            IERC20(_assetAddress).safeTransfer(msg.sender, assetBalance);
        }
        emit LogWithdraw(msg.sender, _assetAddress, 0, assetBalance);
    }

    /**
     * @dev Withdraw asset ERC721
     * @param _assetAddress token address.
     * @param _tokenId token id.
     * @param _notSafe use safeTransfer.
     */
    function _withdrawERC721(
        address _assetAddress,
        uint256 _tokenId,
        bool _notSafe
    ) internal virtual {
        if (_notSafe) {
            IERC721(_assetAddress).transferFrom(
                address(this),
                msg.sender,
                _tokenId
            );
        } else {
            IERC721(_assetAddress).safeTransferFrom(
                address(this),
                msg.sender,
                _tokenId
            );
        }
        emit LogWithdraw(msg.sender, _assetAddress, _tokenId, 1);
    }

    /**
     * @dev Batch withdraw asset ERC721
     * @param _assetAddress token address.
     * @param _tokenIds token ids.
     */
    function _batchWithdrawERC721(
        address _assetAddress,
        uint256[] calldata _tokenIds,
        bool _notSafe
    ) internal virtual {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            _withdrawERC721(_assetAddress, _tokenIds[i], _notSafe);
        }
    }

    /**
     * @dev Withdraw asset ERC1155
     * @param _assetAddress token address.
     * @param _tokenId token id.
     */
    function _withdrawERC1155(address _assetAddress, uint256 _tokenId)
        internal
        virtual
    {
        uint256 assetBalance = IERC1155(_assetAddress).balanceOf(
            address(this),
            _tokenId
        );
        IERC1155(_assetAddress).safeTransferFrom(
            address(this),
            msg.sender,
            _tokenId,
            assetBalance,
            ""
        );
        emit LogWithdraw(msg.sender, _assetAddress, _tokenId, assetBalance);
    }

    /**
     * @dev Batch withdraw asset ERC1155
     * @param _assetAddress token address.
     * @param _tokenIds token ids.
     */
    function _batchWithdrawERC1155(
        address _assetAddress,
        uint256[] calldata _tokenIds
    ) internal virtual {
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            _withdrawERC1155(_assetAddress, _tokenIds[i]);
        }
    }
}

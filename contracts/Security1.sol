// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "./utils/Manageable.sol";
import "./utils/Withdrawable.sol";

/**
 * Ensure that any contracts that inherits from this has level 1 of security
 */

contract Security1 is Manageable, Withdrawable, Pausable {
    constructor(address _governance, address _operator)
        Manageable(_governance, _operator)
    {
        require(governance != address(0), "Governance cannot be null");
    }

    /**
     * @dev Pause all operations
     */
    function SCRAM() public onlyOperatorOrGovernance {
        _pause();
    }

    /**
     * @dev Returns to normal state.
     */
    function unpause() public onlyGovernance {
        _unpause();
    }

    function emergencyWithdrawERC20ETH(address _assetAddress)
        public
        virtual
        onlyGovernance
        whenPaused
    {
        _withdrawERC20ETH(_assetAddress);
    }

    function emergencyWithdrawERC721(
        address _assetAddress,
        uint256 _tokenId,
        bool _notSafe
    ) public virtual onlyGovernance whenPaused {
        _withdrawERC721(_assetAddress, _tokenId, _notSafe);
    }

    function emergencyBatchWithdrawERC721(
        address _assetAddress,
        uint256[] calldata _tokenIds,
        bool _notSafe
    ) public virtual onlyGovernance whenPaused {
        _batchWithdrawERC721(_assetAddress, _tokenIds, _notSafe);
    }

    function emergencyWithdrawERC1155(address _assetAddress, uint256 _tokenId)
        public
        virtual
        onlyGovernance
        whenPaused
    {
        _withdrawERC1155(_assetAddress, _tokenId);
    }

    function emergencyBatchWithdrawERC1155(
        address _assetAddress,
        uint256[] calldata _tokenIds
    ) public virtual onlyGovernance whenPaused {
        _batchWithdrawERC1155(_assetAddress, _tokenIds);
    }
}

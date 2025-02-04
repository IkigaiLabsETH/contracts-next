// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import {MintExtensionERC1155} from "../../../extension/mint/MintExtensionERC1155.sol";
import {IClaimCondition} from "../../../interface/common/IClaimCondition.sol";
import {IFeeConfig} from "../../../interface/common/IFeeConfig.sol";

library MintExtensionERC1155Storage {
    /// @custom:storage-location erc7201:mint.extension.erc1155.storage
    /// @dev keccak256(abi.encode(uint256(keccak256("mint.extension.erc1155.storage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 public constant MINT_EXTENSION_ERC1155_STORAGE_POSITION =
        0xeacf12f8ba47a9d625b8c82a802549746123f2fd21b356c8eb7c698d45931300;

    struct Data {
        /// @notice Mapping from token => token-id => fee config for the token.
        mapping(address => mapping(uint256 => IFeeConfig.FeeConfig)) feeConfig;
        /// @notice Mapping from token => token-id => the claim conditions for minting the token.
        mapping(address => mapping(uint256 => IClaimCondition.ClaimCondition)) claimCondition;
        /// @notice Mapping from hash(claimer, conditionID) => supply claimed by wallet.
        mapping(bytes32 => uint256) supplyClaimedByWallet;
        /// @notice Mapping from token => token-id => condition ID.
        mapping(address => mapping(uint256 => bytes32)) conditionId;
        /// @dev Mapping from permissioned mint request UID => whether the mint request is processed.
        mapping(bytes32 => bool) uidUsed;
    }

    function data() internal pure returns (Data storage data_) {
        bytes32 position = MINT_EXTENSION_ERC1155_STORAGE_POSITION;
        assembly {
            data_.slot := position
        }
    }
}

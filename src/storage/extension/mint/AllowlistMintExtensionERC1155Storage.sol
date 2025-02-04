// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import {AllowlistMintExtensionERC1155} from "../../../extension/mint/AllowlistMintExtensionERC1155.sol";
import {IFeeConfig} from "../../../interface/common/IFeeConfig.sol";

library AllowlistMintExtensionERC1155Storage {
    /// @custom:storage-location erc7201:allowlist.mint.extension.erc1155.storage
    /// @dev keccak256(abi.encode(uint256(keccak256("allowlist.mint.extension.erc1155.storage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 public constant ALLOWLIST_MINT_EXTENSION_ERC1155_STORAGE_POSITION =
        0xd02153fbcd0e763db48525d17a05d8a9bbff9b9c93925268cdc9ad18c2e54200;

    struct Data {
        /// @notice Mapping from token => token-id => the claim conditions for minting the token.
        mapping(address => mapping(uint256 => AllowlistMintExtensionERC1155.ClaimCondition)) claimCondition;
        /// @notice Mapping from token => token-id => fee config for the token.
        mapping(address => mapping(uint256 => IFeeConfig.FeeConfig)) feeConfig;
    }

    function data() internal pure returns (Data storage data_) {
        bytes32 position = ALLOWLIST_MINT_EXTENSION_ERC1155_STORAGE_POSITION;
        assembly {
            data_.slot := position
        }
    }
}

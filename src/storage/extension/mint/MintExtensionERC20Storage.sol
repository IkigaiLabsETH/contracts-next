// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import {MintExtensionERC20} from "../../../extension/mint/MintExtensionERC20.sol";
import {IClaimCondition} from "../../../interface/common/IClaimCondition.sol";
import {IFeeConfig} from "../../../interface/common/IFeeConfig.sol";

library MintExtensionERC20Storage {
    /// @custom:storage-location erc7201:mint.extension.erc20.storage
    /// @dev keccak256(abi.encode(uint256(keccak256("mint.extension.erc20.storage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 public constant MINT_EXTENSION_ERC20_STORAGE_POSITION =
        0x72a325f25024882bfd5c58de04772f8983ae4d34d0b1a84f81f6a4dce8fb2c00;

    struct Data {
        /// @notice Mapping from token => fee config for the token.
        mapping(address => IFeeConfig.FeeConfig) feeConfig;
        /// @notice Mapping from token => the claim conditions for minting the token.
        mapping(address => IClaimCondition.ClaimCondition) claimCondition;
        /// @notice Mapping from hash(claimer, conditionID) => supply claimed by wallet.
        mapping(bytes32 => uint256) supplyClaimedByWallet;
        /// @notice Mapping from token => condition ID.
        mapping(address => bytes32) conditionId;
        /// @dev Mapping from permissioned mint request UID => whether the mint request is processed.
        mapping(bytes32 => bool) uidUsed;
    }

    function data() internal pure returns (Data storage data_) {
        bytes32 position = MINT_EXTENSION_ERC20_STORAGE_POSITION;
        assembly {
            data_.slot := position
        }
    }
}

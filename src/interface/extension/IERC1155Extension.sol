// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import { IExtension } from "./IExtension.sol";

interface IERC1155Extension is IExtension {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted on an attempt to call a extension that is not implemented.
    error ERC1155ExtensionNotImplemented();

    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Returns the signature of the arguments expected by the beforeMint extension.
    function getBeforeMintArgSignature() external view returns (string memory argSignature);

    /*//////////////////////////////////////////////////////////////
                            EXTENSION FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     *  @notice The beforeMint extension that is called by a core token before minting a token.
     *  @param to The address that is minting tokens.
     *  @param id The token ID being minted.
     *  @param value The quantity of tokens to mint.
     *  @param encodedArgs The encoded arguments for the beforeMint extension.
     *  @return tokenIdToMint The tokenId to mint.
     *  @return quantityToMint The quantity of tokens to mint.
     */
    function beforeMint(
        address to,
        uint256 id,
        uint256 value,
        bytes memory encodedArgs
    ) external payable returns (uint256 tokenIdToMint, uint256 quantityToMint);

    /**
     *  @notice The beforeTransfer extension that is called by a core token before transferring a token.
     *  @param from The address that is transferring tokens.
     *  @param to The address that is receiving tokens.
     *  @param id The token ID being transferred.
     *  @param value The quantity of tokens being transferred.
     */
    function beforeTransfer(address from, address to, uint256 id, uint256 value) external;

    /**
     *  @notice The beforeBatchTransfer extension that is called by a core token before batch transferring tokens.
     *  @param from The address that is transferring tokens.
     *  @param to The address that is receiving tokens.
     *  @param ids The token IDs being transferred.
     *  @param values The quantities of tokens being transferred.
     */
    function beforeBatchTransfer(address from, address to, uint256[] calldata ids, uint256[] calldata values) external;

    /**
     *  @notice The beforeBurn extension that is called by a core token before burning a token.
     *  @notice The beforeBurn extension that is called by a core token before burning a token.
     *  @param from The address that is burning tokens.
     *  @param id The token ID being burned.
     *  @param value The quantity of tokens being burned.
     *  @param encodedArgs The encoded arguments for the beforeBurn extension.
     */
    function beforeBurn(address from, uint256 id, uint256 value, bytes memory encodedArgs) external;

    /**
     *  @notice The beforeApprove extension that is called by a core token before approving a token.
     *  @param from The address that is approving tokens.
     *  @param to The address that is being approved.
     *  @param approved Whether to grant or revoke approval.
     */
    function beforeApprove(address from, address to, bool approved) external;

    /**
     *  @notice The uri extension that is called by a core token to retrieve the URI for a token.
     *  @param id The token ID to retrieve the URI for.
     *  @return metadata The URI for the token.
     */
    function uri(uint256 id) external view returns (string memory metadata);

    /**
     *  @notice The royaltyInfo extension that is called by a core token to retrieve the royalty information for a token.
     *  @param id The token ID to retrieve the royalty information for.
     *  @param salePrice The sale price of the token.
     *  @return receiver The address to send the royalty payment to.
     *  @return royaltyAmount The amount of royalty to pay.
     */
    function royaltyInfo(uint256 id, uint256 salePrice) external view returns (address receiver, uint256 royaltyAmount);
}

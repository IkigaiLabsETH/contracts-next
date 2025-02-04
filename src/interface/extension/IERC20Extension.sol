// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import {IExtension} from "./IExtension.sol";

interface IERC20Extension is IExtension {
    /*//////////////////////////////////////////////////////////////
                                  ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted on an attempt to call a extension that is not implemented.
    error ERC20ExtensionNotImplemented();

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
     *  @param amount The quantity of tokens to mint.
     *  @param encodedArgs The encoded arguments for the beforeMint extension.
     *  @return quantityToMint The quantity of tokens to mint.s
     */
    function beforeMint(address to, uint256 amount, bytes memory encodedArgs)
        external
        payable
        returns (uint256 quantityToMint);

    /**
     *  @notice The beforeTransfer extension that is called by a core token before transferring a token.
     *  @param from The address that is transferring tokens.
     *  @param to The address that is receiving tokens.
     *  @param amount The quantity of tokens to transfer.
     */
    function beforeTransfer(address from, address to, uint256 amount) external;

    /**
     *  @notice The beforeBurn extension that is called by a core token before burning a token.
     *  @param from The address that is burning tokens.
     *  @param amount The quantity of tokens to burn.
     *  @param encodedArgs The encoded arguments for the beforeBurn extension.
     */
    function beforeBurn(address from, uint256 amount, bytes memory encodedArgs) external;

    /**
     *  @notice The beforeApprove extension that is called by a core token before approving a token.
     *  @param from The address that is approving tokens.
     *  @param to The address that is being approved.
     *  @param amount The quantity of tokens to approve.
     */
    function beforeApprove(address from, address to, uint256 amount) external;
}

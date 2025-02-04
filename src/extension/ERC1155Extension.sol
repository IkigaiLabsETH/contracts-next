// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.0;

import "../common/Initializable.sol";
import "../common/UUPSUpgradeable.sol";
import "../common/Permission.sol";

import { IERC1155Extension } from "../interface/extension/IERC1155Extension.sol";

abstract contract ERC1155Extension is Initializable, UUPSUpgradeable, Permission, IERC1155Extension {
    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Bits representing the before mint extension.
    function BEFORE_MINT_FLAG() public pure virtual returns (uint256) {
        return 2 ** 1;
    }

    /// @notice Bits representing the before transfer extension.
    function BEFORE_TRANSFER_FLAG() public pure virtual returns (uint256) {
        return 2 ** 2;
    }

    /// @notice Bits representing the before transfer extension.
    function BEFORE_BATCH_TRANSFER_FLAG() public pure virtual returns (uint256) {
        return 2 ** 3;
    }

    /// @notice Bits representing the before burn extension.
    function BEFORE_BURN_FLAG() public pure virtual returns (uint256) {
        return 2 ** 4;
    }

    /// @notice Bits representing the before approve extension.
    function BEFORE_APPROVE_FLAG() public pure virtual returns (uint256) {
        return 2 ** 5;
    }

    /// @notice Bits representing the token URI extension.
    function TOKEN_URI_FLAG() public pure virtual returns (uint256) {
        return 2 ** 6;
    }

    /// @notice Bits representing the royalty extension.
    function ROYALTY_INFO_FLAG() public pure virtual returns (uint256) {
        return 2 ** 7;
    }

    /*//////////////////////////////////////////////////////////////
                                ERROR
    //////////////////////////////////////////////////////////////*/

    error ERC1155UnauthorizedUpgrade();

    /*//////////////////////////////////////////////////////////////
                     CONSTRUCTOR & INITIALIZE
    //////////////////////////////////////////////////////////////*/

    constructor() {
        _disableInitializers();
    }

    /// @notice Initializes the contract. Grants admin role (i.e. upgrade authority) to given `_upgradeAdmin`.
    function __ERC1155Extension_init(address _upgradeAdmin) public onlyInitializing {
        _setupRole(_upgradeAdmin, ADMIN_ROLE_BITS);
    }

    /// @notice Checks if `msg.sender` is authorized to upgrade the proxy to `newImplementation`, reverting if not.
    function _authorizeUpgrade(address) internal view override {
        if (!hasRole(msg.sender, ADMIN_ROLE_BITS)) {
            revert ERC1155UnauthorizedUpgrade();
        }
    }

    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Returns the signature of the arguments expected by the beforeMint extension.
    function getBeforeMintArgSignature() external view virtual returns (string memory argSignature) {
        argSignature = "";
    }

    /// @notice Returns the signature of the arguments expected by the beforeBurn extension.
    function getBeforeBurnArgSignature() external view virtual returns (string memory argSignature) {
        argSignature = "";
    }

    /*//////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     *  @notice The beforeMint extension that is called by a core token before minting a token.
     *  @param _to The address that is minting tokens.
     *  @param _id The token ID being minted.
     *  @param _value The quantity of tokens to mint.
     *  @param _encodedArgs The encoded arguments for the beforeMint extension.
     *  @return tokenIdToMint The start tokenId to mint.
     *  @return quantityToMint The quantity of tokens to mint.
     */
    function beforeMint(
        address _to,
        uint256 _id,
        uint256 _value,
        bytes memory _encodedArgs
    ) external payable virtual returns (uint256 tokenIdToMint, uint256 quantityToMint) {
        revert ERC1155ExtensionNotImplemented();
    }

    /**
     *  @notice The beforeTransfer extension that is called by a core token before transferring a token.
     *  @param _from The address that is transferring tokens.
     *  @param _to The address that is receiving tokens.
     *  @param _id The token ID being transferred.
     *  @param _value The quantity of tokens being transferred.
     */
    function beforeTransfer(address _from, address _to, uint256 _id, uint256 _value) external virtual {
        revert ERC1155ExtensionNotImplemented();
    }

    /**
     *  @notice The beforeBatchTransfer extension that is called by a core token before batch transferring tokens.
     *  @param from The address that is transferring tokens.
     *  @param to The address that is receiving tokens.
     *  @param ids The token IDs being transferred.
     *  @param values The quantities of tokens being transferred.
     */
    function beforeBatchTransfer(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values
    ) external virtual {
        revert ERC1155ExtensionNotImplemented();
    }

    /**
     *  @notice The beforeBurn extension that is called by a core token before burning a token.
     *  @notice The beforeBurn extension that is called by a core token before burning a token.
     *  @param _from The address that is burning tokens.
     *  @param _id The token ID being burned.
     *  @param _value The quantity of tokens being burned.
     *  @param _encodedArgs The encoded arguments for the beforeBurn extension.
     */
    function beforeBurn(address _from, uint256 _id, uint256 _value, bytes memory _encodedArgs) external virtual {
        revert ERC1155ExtensionNotImplemented();
    }

    /**
     *  @notice The beforeApprove extension that is called by a core token before approving a token.
     *  @param _from The address that is approving tokens.
     *  @param _to The address that is being approved.
     *  @param _approved Whether to grant or revoke approval.
     */
    function beforeApprove(address _from, address _to, bool _approved) external virtual {
        revert ERC1155ExtensionNotImplemented();
    }

    /**
     *  @notice The uri extension that is called by a core token to retrieve the URI for a token.
     *  @param _id The token ID to retrieve the URI for.
     *  @return metadata The URI for the token.
     */
    function uri(uint256 _id) external view virtual returns (string memory metadata) {
        revert ERC1155ExtensionNotImplemented();
    }

    /**
     *  @notice The royaltyInfo extension that is called by a core token to retrieve the royalty information for a token.
     *  @param _id The token ID to retrieve the royalty information for.
     *  @param _salePrice The sale price of the token.
     *  @return receiver The address to send the royalty payment to.
     *  @return royaltyAmount The amount of royalty to pay.
     */
    function royaltyInfo(
        uint256 _id,
        uint256 _salePrice
    ) external view virtual returns (address receiver, uint256 royaltyAmount) {
        revert ERC1155ExtensionNotImplemented();
    }
}

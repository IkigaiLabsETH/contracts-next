// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.0;

import "../common/Initializable.sol";
import "../common/UUPSUpgradeable.sol";
import "../common/Permission.sol";

import { IERC721Extension } from "../interface/extension/IERC721Extension.sol";

abstract contract ERC721Extension is Initializable, UUPSUpgradeable, Permission, IERC721Extension {
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

    /// @notice Bits representing the before burn extension.
    function BEFORE_BURN_FLAG() public pure virtual returns (uint256) {
        return 2 ** 3;
    }

    /// @notice Bits representing the before approve extension.
    function BEFORE_APPROVE_FLAG() public pure virtual returns (uint256) {
        return 2 ** 4;
    }

    /// @notice Bits representing the token URI extension.
    function TOKEN_URI_FLAG() public pure virtual returns (uint256) {
        return 2 ** 5;
    }

    /// @notice Bits representing the royalty extension.
    function ROYALTY_INFO_FLAG() public pure virtual returns (uint256) {
        return 2 ** 6;
    }

    /*//////////////////////////////////////////////////////////////
                                ERROR
    //////////////////////////////////////////////////////////////*/

    error ERC721UnauthorizedUpgrade();

    /*//////////////////////////////////////////////////////////////
                     CONSTRUCTOR & INITIALIZE
    //////////////////////////////////////////////////////////////*/

    constructor() {
        _disableInitializers();
    }

    /// @notice Initializes the contract. Grants admin role (i.e. upgrade authority) to given `_upgradeAdmin`.
    function __ERC721Extension_init(address _upgradeAdmin) public onlyInitializing {
        _setupRole(_upgradeAdmin, ADMIN_ROLE_BITS);
    }

    /// @notice Checks if `msg.sender` is authorized to upgrade the proxy to `newImplementation`, reverting if not.
    function _authorizeUpgrade(address) internal view override {
        if (!hasRole(msg.sender, ADMIN_ROLE_BITS)) {
            revert ERC721UnauthorizedUpgrade();
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
     *  @param _quantity The quantity of tokens to mint.
     *  @param _encodedArgs The encoded arguments for the beforeMint extension.
     *  @return tokenIdToMint The start tokenId to mint.
     *  @return quantityToMint The quantity of tokens to mint.
     */
    function beforeMint(
        address _to,
        uint256 _quantity,
        bytes memory _encodedArgs
    ) external payable virtual returns (uint256 tokenIdToMint, uint256 quantityToMint) {
        revert ERC721ExtensionNotImplemented();
    }

    /**
     *  @notice The beforeTransfer extension that is called by a core token before transferring a token.
     *  @param _from The address that is transferring tokens.
     *  @param _to The address that is receiving tokens.
     *  @param _tokenId The token ID being transferred.
     */
    function beforeTransfer(address _from, address _to, uint256 _tokenId) external virtual {
        revert ERC721ExtensionNotImplemented();
    }

    /**
     *  @notice The beforeBurn extension that is called by a core token before burning a token.
     *  @param _from The address that is burning tokens.
     *  @param _tokenId The token ID being burned.
     *  @param _encodedArgs The encoded arguments for the beforeBurn extension.
     */
    function beforeBurn(address _from, uint256 _tokenId, bytes memory _encodedArgs) external virtual {
        revert ERC721ExtensionNotImplemented();
    }

    /**
     *  @notice The beforeApprove extension that is called by a core token before approving a token.
     *  @param _from The address that is approving tokens.
     *  @param _to The address that is being approved.
     *  @param _tokenId The token ID being approved.
     *  @param _approve The approval status to set.
     */
    function beforeApprove(address _from, address _to, uint256 _tokenId, bool _approve) external virtual {
        revert ERC721ExtensionNotImplemented();
    }

    /**
     *  @notice Returns the URI to fetch token metadata from.
     *  @dev Meant to be called by the core token contract.
     *  @param tokenId The token ID of the NFT.
     *  @return metadata The URI to fetch token metadata from.
     */
    function tokenURI(uint256 tokenId) external view virtual returns (string memory metadata) {
        revert ERC721ExtensionNotImplemented();
    }

    /**
     *  @notice Returns the royalty recipient and amount for a given sale.
     *  @dev Meant to be called by a token contract.
     *  @param tokenId The token ID of the NFT.
     *  @param salePrice The sale price of the NFT.
     *  @return receiver The royalty recipient address.
     *  @return royaltyAmount The royalty amount to send to the recipient as part of a sale.
     */
    function royaltyInfo(
        uint256 tokenId,
        uint256 salePrice
    ) external view virtual returns (address receiver, uint256 royaltyAmount) {
        revert ERC721ExtensionNotImplemented();
    }
}

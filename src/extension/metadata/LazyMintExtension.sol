// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import {IPermission} from "../../interface/common/IPermission.sol";

import {ERC721Extension} from "../ERC721Extension.sol";
import {LibString} from "../../lib/LibString.sol";

import {LazyMintStorage} from "../../storage/extension/metadata/LazyMintStorage.sol";

contract LazyMintExtension is ERC721Extension {
    using LibString for uint256;

    /*//////////////////////////////////////////////////////////////
                               EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @dev Emitted when tokens are lazy minted.
    event TokensLazyMinted(
        address indexed token, uint256 indexed startTokenId, uint256 endTokenId, string baseURI, bytes encryptedBaseURI
    );

    /*//////////////////////////////////////////////////////////////
                               ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted when caller is not token core admin.
    error LazyMintExtensionNotAuthorized();

    /// @notice Emitted when querying an invalid index in a batch array.
    error LazyMintExtensionInvalidIndex();

    /// @notice Emitted when lazy minting zero tokens.
    error LazyMintExtensionZeroAmount();

    /// @notice Emitted when querying URI for a non-existent invalid token ID.
    error LazyMintExtensionInvalidTokenId();

    /*//////////////////////////////////////////////////////////////
                               MODIFIER
    //////////////////////////////////////////////////////////////*/

    /// @notice Checks whether the caller is an admin of the given token.
    modifier onlyAdmin(address _token) {
        if (!IPermission(_token).hasRole(msg.sender, ADMIN_ROLE_BITS)) {
            revert LazyMintExtensionNotAuthorized();
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                INITIALIZE
    //////////////////////////////////////////////////////////////*/

    function initialize(address _upgradeAdmin) public initializer {
        __ERC721Extension_init(_upgradeAdmin);
    }

    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Returns all extension functions implemented by this extension contract.
    function getExtensions() external pure returns (uint256 extensionsImplemented) {
        extensionsImplemented = TOKEN_URI_FLAG();
    }

    /**
     *  @notice Returns the count of batches of NFTs for a token.
     *  @param _token The token address.
     */
    function getBaseURICount(address _token) public view returns (uint256) {
        return LazyMintStorage.data().batchIds[_token].length;
    }

    /**
     *  @notice Returns the URI to fetch token metadata from.
     *  @dev Meant to be called by the core token contract.
     *  @param _id The token ID of the NFT.
     */
    function tokenURI(uint256 _id) public view override returns (string memory) {
        address token = msg.sender;
        string memory batchUri = _getBaseURI(token, _id);

        return string(abi.encodePacked(batchUri, _id.toString()));
    }

    /**
     *  @notice Returns the URI to fetch token metadata from.
     *  @dev Meant to be called by the core token contract.
     *  @param _id The token ID of the NFT.
     */
    function uri(uint256 _id) external view returns (string memory) {
        return tokenURI(_id);
    }

    /**
     *  @notice Returns the ID for the batch of tokens at the given index.
     *  @param _token The token address.
     *  @param _index The index of the batch.
     */
    function getBatchIdAtIndex(address _token, uint256 _index) public view returns (uint256) {
        if (_index >= getBaseURICount(_token)) {
            revert LazyMintExtensionInvalidIndex();
        }
        return LazyMintStorage.data().batchIds[_token][_index];
    }

    /*//////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     *  @notice Lazy mints a given amount of NFTs.
     *  @param _token The token address.
     *  @param _amount The number of NFTs to lazy mint.
     *  @param _baseURIForTokens Base URI for a batch of NFTs.
     *  @param _data Additional bytes data
     *  @return batchId A unique integer identifier for the batch of NFTs lazy minted together.
     */
    function lazyMint(address _token, uint256 _amount, string calldata _baseURIForTokens, bytes calldata _data)
        public
        virtual
        onlyAdmin(_token)
        returns (uint256 batchId)
    {
        if (_amount == 0) {
            revert LazyMintExtensionZeroAmount();
        }

        LazyMintStorage.Data storage data = LazyMintStorage.data();

        uint256 startId = data.nextTokenIdToLazyMint[_token];
        (data.nextTokenIdToLazyMint[_token], batchId) = _batchMintMetadata(_token, startId, _amount, _baseURIForTokens);

        emit TokensLazyMinted(_token, startId, startId + _amount - 1, _baseURIForTokens, _data);

        return batchId;
    }

    /*//////////////////////////////////////////////////////////////
                            INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @dev Mints a batch of tokenIds and associates a common baseURI to all those Ids.
    function _batchMintMetadata(
        address _token,
        uint256 _startId,
        uint256 _amountToMint,
        string memory _baseURIForTokens
    ) internal returns (uint256 nextTokenIdToMint, uint256 batchId) {
        batchId = _startId + _amountToMint;
        nextTokenIdToMint = batchId;

        LazyMintStorage.Data storage data = LazyMintStorage.data();

        data.batchIds[_token].push(batchId);
        data.baseURI[_token][batchId] = _baseURIForTokens;
    }

    /// @dev Returns the baseURI for a token. The intended metadata URI for the token is baseURI + tokenId.
    function _getBaseURI(address _token, uint256 _tokenId) internal view returns (string memory) {
        uint256 numOfTokenBatches = getBaseURICount(_token);

        LazyMintStorage.Data storage data = LazyMintStorage.data();

        uint256[] memory indices = data.batchIds[_token];

        for (uint256 i = 0; i < numOfTokenBatches; i += 1) {
            if (_tokenId < indices[i]) {
                return data.baseURI[_token][indices[i]];
            }
        }
        revert LazyMintExtensionInvalidTokenId();
    }
}

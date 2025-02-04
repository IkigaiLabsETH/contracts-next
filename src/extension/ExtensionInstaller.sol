// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import {LibBitmap} from "../lib/LibBitmap.sol";
import {IExtension} from "../interface/extension/IExtension.sol";
import {IExtensionInstaller} from "../interface/extension/IExtensionInstaller.sol";

import {ExtensionInstallerStorage} from "../storage/extension/ExtensionInstallerStorage.sol";

abstract contract ExtensionInstaller is IExtensionInstaller {
    using LibBitmap for LibBitmap.Bitmap;

    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     *  @notice Retusn the implementation of a given extension, if any.
     *  @param _flag The bits representing the extension.
     *  @return impl The implementation of the extension.
     */
    function getExtensionImplementation(uint256 _flag) public view returns (address) {
        return ExtensionInstallerStorage.data().extensionImplementationMap[_flag];
    }

    /*//////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     *  @notice Installs a extension in the contract.
     *  @dev Maps all extension functions implemented by the extension to the extension's address.
     *  @param _extension The extension to install.
     */
    function installExtension(IExtension _extension) external {
        if (!_canUpdateExtensions(msg.sender)) {
            revert ExtensionsNotAuthorized();
        }
        _installExtension(_extension);
    }

    /**
     *  @notice Uninstalls a extension in the contract.
     *  @dev Reverts if the extension is not installed already.
     *  @param _extension The extension to uninstall.
     */
    function uninstallExtension(IExtension _extension) external {
        if (!_canUpdateExtensions(msg.sender)) {
            revert ExtensionsNotAuthorized();
        }
        _uninstallExtension(_extension);
    }

    /*//////////////////////////////////////////////////////////////
                            INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @dev Returns whether the caller can update extensions.
    function _canUpdateExtensions(address _caller) internal view virtual returns (bool);

    /// @dev Should return the max flag that represents a extension.
    function _maxExtensionFlag() internal pure virtual returns (uint256) {
        return 0;
    }

    /// @dev Installs a extension in the contract.
    function _installExtension(IExtension _extension) internal {
        uint256 extensionsToInstall = _extension.getExtensions();

        _updateExtensions(extensionsToInstall, address(_extension), _addExtension);
        ExtensionInstallerStorage.data().extensionImplementations.set(uint160(address(_extension)));

        emit ExtensionsInstalled(address(_extension), extensionsToInstall);
    }

    /// @dev Uninstalls a extension in the contract.
    function _uninstallExtension(IExtension _extension) internal {
        ExtensionInstallerStorage.Data storage data = ExtensionInstallerStorage.data();

        if (!data.extensionImplementations.get(uint160(address(_extension)))) {
            revert ExtensionsNotInstalled();
        }

        uint256 extensionsToUninstall = _extension.getExtensions();

        _updateExtensions(extensionsToUninstall, address(0), _removeExtension);
        data.extensionImplementations.unset(uint160(address(_extension)));

        emit ExtensionsUninstalled(address(_extension), extensionsToUninstall);
    }

    /// @dev Adds a extension to the given integer represented extensions.
    function _addExtension(uint256 _flag, uint256 _currentExtensions) internal pure returns (uint256) {
        if (_currentExtensions & _flag > 0) {
            revert ExtensionsAlreadyInstalled();
        }
        return _currentExtensions | _flag;
    }

    /// @dev Removes a extension from the given integer represented extensions.
    function _removeExtension(uint256 _flag, uint256 _currentExtensions) internal pure returns (uint256) {
        return _currentExtensions & ~_flag;
    }

    /// @dev Updates the current active extensions of the contract.
    function _updateExtensions(
        uint256 _extensionsToUpdate,
        address _implementation,
        function(uint256, uint256) internal pure returns (uint256) _addOrRemoveExtension
    ) internal {
        ExtensionInstallerStorage.Data storage data = ExtensionInstallerStorage.data();

        uint256 currentActiveExtensions = data.installedExtensions;

        uint256 flag = 2 ** _maxExtensionFlag();
        while (flag > 1) {
            if (_extensionsToUpdate & flag > 0) {
                currentActiveExtensions = _addOrRemoveExtension(flag, currentActiveExtensions);
                data.extensionImplementationMap[flag] = _implementation;
            }

            flag >>= 1;
        }

        data.installedExtensions = currentActiveExtensions;
    }
}

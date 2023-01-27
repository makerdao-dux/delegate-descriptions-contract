// SPDX-License-Identifier: MIT
pragma solidity >0.8.9;

interface IDelegatesFactory {
    function delegates(address) external view returns (address);
    function isDelegate(address) external view returns (bool);

}
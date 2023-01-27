// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IDelegatesFactory.sol";


// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract DelegateDescriptions is Ownable {
    // Struct to store the delegate hash and the hash type
    struct delegateHash {
        bytes32 hash;
        uint256 hashType;
    }
    
    // Mapping to store the different delegate hashes. Only owners of a delegate contract can set their own hash.
    mapping(address => delegateHash) public delegateProfileHashes;

    // Mapping to store the different allowed delegate hash storages
    // For example: 1 -> IPFS, 2 -> Arweave, etc.
    mapping(uint256 => bytes32) public hashTypes;

    // Mapping to store the root file hashes
    mapping(uint256 => bytes32) public rootFileHashes;

    address payable public govAlphaAddress;
    
    // Event to be emitted when the owner changes the govAlphaAddress
    event GovAlphaAddressChanged(address govAlphaAddress);

    // Allow the owner to change the govAlphaAddress
    function setGovAlphaAddress(address payable _govAlphaAddress) public onlyOwner {
        govAlphaAddress = _govAlphaAddress;
        emit GovAlphaAddressChanged(_govAlphaAddress);
    }

    // Stores a reference to the delegates factory
    IDelegatesFactory public delegatesFactory;

    // In case someone sends Ether to this contract, we don't want it to be lost
    function ownerWithdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // Event to be emitted when a hash type is set
    event HashTypeChanged(uint256 index, bytes32 hashType);

    // Sets a hash type in the hashTypes mapping, only the owner can do this
    function setHashType(uint256 index, bytes32 hashType) public onlyOwner {
        hashTypes[index] = hashType;
        emit HashTypeChanged(index, hashType);
    }

    // Event to be emitted when a delegate hash is set
    event DelegateHashChanged(address delegateContractAddress, bytes32 delegateHash, uint256 hashType);

    // Sets a delegate hash for a delegate contract address. Only the owner of the delegate contract can do this
    function setDelegateHash(address delegateContractAddress, bytes32 _delegateHash, uint256 hashType) public {
        // Sender has to be a delegate
        require(delegatesFactory.isDelegate(msg.sender), "INVALID_DELEGATE_CONTRACT_ADDRESS");
        // delegateContractAddress has to be owned by the sender
        require(delegatesFactory.delegates(msg.sender) == delegateContractAddress, "INVALID_DELEGATE_CONTRACT_ADDRESS");
        // hashType has to be a valid hash type
        require(hashTypes[hashType] != bytes32(0), "INVALID_HASH_TYPE");

        delegateProfileHashes[delegateContractAddress] = delegateHash(_delegateHash, hashType);

        emit DelegateHashChanged(delegateContractAddress, _delegateHash, hashType);
    }

    // Event to be emitted when a root file hash is set
    event RootFileHashChanged(bytes32 rootFileHash, uint256 hashType);

    // Set the hashes for the delegates index
    function setRootFileHash(bytes32 hash, uint256 _hashType) public {
        // Sender has to be the govAlphaAddress
        require(msg.sender == govAlphaAddress, "INVALID_GOVALPHA_ADDRESS");
        // hashType has to be a valid hash type
        require(hashTypes[_hashType] != bytes32(0), "INVALID_HASH_TYPE");

        // Set the root file hash
        rootFileHashes[_hashType] = hash;

        emit RootFileHashChanged(hash, _hashType);
    }


    constructor(address _delegatesFactoryAddress) payable {
        require(_delegatesFactoryAddress != address(0), "INVALID_DELEGATES_FACTORY_ADDRESS");
        delegatesFactory = IDelegatesFactory(_delegatesFactoryAddress);

        // Set the default hash types
        hashTypes[1] = "IPFS";
        hashTypes[2] = "ARWEAVE";
        
    }

}

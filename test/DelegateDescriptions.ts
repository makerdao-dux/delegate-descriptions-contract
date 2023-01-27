// Delegate factory Mainnet 0xD897F108670903D1d6070fcf818f9db3615AF272
// Delegate factory goerli 0xE2d249AE3c156b132C40D07bd4d34e73c1712947
import { expect } from "chai";
import { ethers } from "hardhat";

// Test suite should run as a fork of mainnet
const delegateFactoryMainnet = "0xD897F108670903D1d6070fcf818f9db3615AF272"

describe('Delegate Descriptions', () => {
    it('Initializes the contract correctly', async () => {
        const DelegateDescriptions = await ethers.getContractFactory("DelegateDescriptions");

        const delegateDescriptions = await DelegateDescriptions.deploy(delegateFactoryMainnet);
        await delegateDescriptions.deployed();
        expect(delegateDescriptions.address.length).to.be.greaterThan(0);
    });

    it('Allows a delegate to be added', async () => {
        const DelegateDescriptions = await ethers.getContractFactory("DelegateDescriptions");

        const delegateDescriptions = await DelegateDescriptions.deploy(delegateFactoryMainnet);
        await delegateDescriptions.deployed();

        // Delegate contract address
        const delegateContractAddress = "0x84b05b0a30b6ae620f393d1037f217e607ad1b96";
        // We impersonate the owner of the delegate contract
        const delegateContractOwner = '0x62a43123fe71f9764f26554b3f5017627996816a'
        const impersonatedSigner = await ethers.getImpersonatedSigner(delegateContractOwner);

        const hash = "Somehash";
        const hashType = 1;
        await delegateDescriptions.connect(impersonatedSigner).setDelegateHash(delegateContractAddress, hash , hashType);
        const delegateHash = await delegateDescriptions.delegateProfileHashes(delegateContractAddress);

        expect(delegateHash.hash).to.equal(hash);
        expect(delegateHash.hashType).to.equal(hashType);
    });
})
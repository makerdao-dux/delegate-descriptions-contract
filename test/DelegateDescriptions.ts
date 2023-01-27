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
    })
})
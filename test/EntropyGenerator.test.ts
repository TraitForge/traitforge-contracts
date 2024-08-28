import { expect } from 'chai';
import { ethers } from 'hardhat';
import { EntropyGenerator } from '../typechain-types';
import { HardhatEthersSigner } from '@nomicfoundation/hardhat-ethers/signers';

describe('EntropyGenerator', function () {
  let entropyGenerator: EntropyGenerator;
  let owner: HardhatEthersSigner;
  let allowedCaller: HardhatEthersSigner;

  before(async function () {
    [owner, allowedCaller] = await ethers.getSigners();

    const NFT = await ethers.getContractFactory('TraitForgeNft');
    const nft = await NFT.deploy();
    await nft.waitForDeployment();

    // Deploy the contract
    const EntropyGenerator = await ethers.getContractFactory(
      'EntropyGenerator'
    );
    entropyGenerator = await EntropyGenerator.deploy(await nft.getAddress());

    await entropyGenerator.waitForDeployment();
  });

  it('should set the allowed caller', async function () {
    await entropyGenerator.connect(owner).setAllowedCaller(allowedCaller);

    // Use the new getter function to retrieve the allowedCaller
    const updatedCaller = await entropyGenerator.getAllowedCaller();
    expect(updatedCaller).to.equal(allowedCaller);
  });

  it('should retrieve the next entropy', async function () {
    // Call getNextEntropy and wait for the transaction to be mined
    await expect(
      entropyGenerator.connect(allowedCaller).getNextEntropy()
    ).to.emit(entropyGenerator, 'EntropyRetrieved');

    // If you have specific expectations about the entropy value, compare it here
    // For example: expect(entropyValue).to.equal(expectedValue);
  });
});

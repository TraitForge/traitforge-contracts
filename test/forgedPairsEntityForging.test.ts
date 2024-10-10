import { assert, parseEther } from 'ethers';
import {
  Airdrop,
  DevFund,
  EntityForging,
  EntropyGenerator,
  EntityTrading,
  NukeFund,
  TraitForgeNft,
} from '../typechain-types';
import { HardhatEthersSigner } from '@nomicfoundation/hardhat-ethers/signers';
import generateMerkleTree from '../scripts/genMerkleTreeLib';

const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('EntityForging', () => {
  const formerEntityContractAddress =
    '0xE1d5493b321d16e12c747bEc0E1ab4d4dBBf1AF9';
  const newEntityContractAddress = '0xCAD8EfdF86252FB024F4E03cC1Fa44f8130d2FAf';
  const protocolMaintainerAddress =
    '0x225b791581185B73Eb52156942369843E8B0Eec7';
  const waleETHAddress = '0xF977814e90dA44bFA03b6295A0616a897441aceC';
  let formerEntityForging: EntityForging;
  let newEntityForging: EntityForging;
  let nft: TraitForgeNft;
  let protocolMaintainer: HardhatEthersSigner;
  let waleETH: HardhatEthersSigner;
  let user1: HardhatEthersSigner;
  let user2: HardhatEthersSigner;
  let user3: HardhatEthersSigner;
  let entityTrading: EntityTrading;
  let nukeFund: NukeFund;
  let devFund: DevFund;
  let FORGER_TOKEN_ID: number;
  let MERGER_TOKEN_ID: number;

  const FORGING_FEE = ethers.parseEther('1.0'); // 1 ETH

  it.only('should migrate forgedPairs', async () => {
    console.log('Migrating forgedPairs');
    protocolMaintainer = await ethers.getImpersonatedSigner(
      protocolMaintainerAddress
    );
    waleETH = await ethers.getImpersonatedSigner(waleETHAddress);
    [user1, user2, user3] = await ethers.getSigners();
    await waleETH.sendTransaction({
      to: protocolMaintainer.address,
      value: parseEther('10'),
    });

    const EntityForging = await ethers.getContractFactory('EntityForging');
    formerEntityForging = (await EntityForging.attach(
      formerEntityContractAddress
    )) as EntityForging;
    newEntityForging = (await EntityForging.attach(
      newEntityContractAddress
    )) as EntityForging;

    await fetchPastEvents();

    async function fetchPastEvents() {
      const filter = formerEntityForging.filters.EntityForged();
      const events = await formerEntityForging.queryFilter(filter, 0, 'latest');
      console.log('events: ', events.length);

      let count = 0;
      const lowerIds = [];
      const higherIds = [];
      let tt_count = 0;
      for (const event of events) {
        count++;
        const log = {
          data: event.data,
          topics: event.topics,
        };
        // const newTokenid = BigInt(log.topics[1]).toString();
        const parent1Id = BigInt(log.topics[2]).toString();
        const parent2Id = BigInt(log.topics[3]).toString();
        // Récupération du bloc contenant l'événement
        // const block = await ethers.getBlock(event.blockNumber);

        // // Récupération du timestamp du bloc
        // const timestamp = block?.timestamp;

        // console.log(`Block time: ${new Date(timestamp * 1000).toLocaleString()}`);
        // console.log(`Block Timestamp: ${timestamp} `);
        // console.log(`forge N°: ${count}`);

        // console.log(`Past Event - New Token ID: ${newTokenid}`);
        // console.log(`Past Event - Parent 1 ID: ${parent1Id}`);
        // console.log(`Past Event - Parent 2 ID: ${parent2Id}`);

        const lowerId = parent1Id < parent2Id ? parent1Id : parent2Id;
        const higherId = parent1Id < parent2Id ? parent2Id : parent1Id;

        lowerIds.push(lowerId);
        higherIds.push(higherId);
        console.log('lowerId: ', lowerId);
        console.log('higherId: ', higherId);
        if (lowerId == '2174' || higherId == '2174') {
          tt_count++;
        }

        console.log(
          '//////////////////////////////////////////////////////////////////'
        );

        // const { forgerId, mergerId } = event.args;

        // // Récupérer le bloc correspondant à l'événement
        // const block = await provider.getBlock(event.blockNumber);
        // const timestamp = block.timestamp;

        // console.log(`Past Event - Forger ID: ${forgerId.toString()}, Merger ID: ${mergerId.toString()}`);
        // console.log(`Block Timestamp: ${new Date(timestamp * 1000).toLocaleString()}`);
      }
      await migrateForgedPairsData(protocolMaintainer, lowerIds, higherIds);
      const t_count = await newEntityForging.forgingCounts(2174);
      expect(t_count).to.equal(tt_count);
      
    }

    async function migrateForgedPairsData(
      signer: HardhatEthersSigner,
      lowerIds: string[],
      higherIds: string[]
    ) {
      // Créez un wallet à partir d'une clé privée (ou utilisez un fournisseur Web3 comme Metamask)
      // const signer = new ethers.Wallet('<YOUR_PRIVATE_KEY>', provider); // Remplacez par votre clé privée

      // Connecter le signer au contrat pour autoriser les transactions
      const contractWithSigner = newEntityForging.connect(signer) as any;

      // Appel de la fonction migrateForgedPairsData
      try {
        const tx = await contractWithSigner.migrateForgedPairsData(
          lowerIds,
          higherIds
        );
        console.log('Tx send, hash:', tx.hash);

        // Attendre la confirmation de la transaction
        const receipt = await tx.wait();
        console.log('Transaction confirmée, receipt:', receipt);
      } catch (error) {
        console.error('Erreur lors de la migration des IDs:', error);
      }
    }
  });
});

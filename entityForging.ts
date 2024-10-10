import { ethers, JsonRpcProvider, Contract } from 'ethers';

// Configuration de l'URL du fournisseur (Infura, Alchemy, etc.)
const provider = new JsonRpcProvider(
  'https://base-mainnet.g.alchemy.com/v2/I1apVxxJiVOtpmWVQWZZ_v6An5mq7hAa'
);

// Adresse du contrat EntityForging
const entityForgingAddress = '0xE1d5493b321d16e12c747bEc0E1ab4d4dBBf1AF9';
const newEntityForgingAddress = '0xNEW_CONTRACT_ADDRESS'; // Remplacez par l'adresse de votre nouveau contrat

// ABI du contrat (seulement la partie pour l'événement EntityForged)
const entityForgingABI = [
  'event EntityForged(uint256 indexed newTokenId, uint256 forgerId, uint256 mergerId, uint256 newEntropy, uint256 fee)',
  'function migrateForgedPairsData(uint256[] memory lowerIds, uint256[] memory higherIds) external',
];

// Création de l'instance du contrat
const entityForgingContract = new Contract(
  entityForgingAddress,
  entityForgingABI,
  provider
);

const newEntityForgingContract = new Contract(
  newEntityForgingAddress,
  entityForgingABI,
  provider
);

// Listener pour capturer les événements EntityForged
entityForgingContract.on(
  'EntityForged',
  async (newTokenId, forgerId, mergerId, newEntropy, fee, event) => {
    console.log('Entity Forged Event Detected!');

    // Récupération du bloc contenant l'événement
    const block = await provider.getBlock(event.blockNumber);

    // Récupération du timestamp du bloc
    const timestamp = block?.timestamp;

    console.log(`Forger ID: ${forgerId.toString()}`);
    console.log(`Merger ID: ${mergerId.toString()}`);
    console.log(`New Token ID: ${newTokenId.toString()}`);
    console.log(`New Entropy: ${newEntropy.toString()}`);
    console.log(`Fee: ${fee.toString()}`);
    if (timestamp) {
      console.log(
        `Block Timestamp: ${new Date(timestamp * 1000).toLocaleString()}`
      );
    } else {
      console.log('Block Timestamp not available');
    }

    // Vous pouvez également accéder aux détails de l'événement
    console.log(event);
  }
);

// Optionnel: Fonction pour récupérer les événements passés avec le timestamp
async function fetchPastEvents() {
  const filter = entityForgingContract.filters.EntityForged();
  const events = await entityForgingContract.queryFilter(filter, 0, 'latest');
  console.log('events: ', events.length);

  let count = 0;
  const lowerIds = [];
  const higherIds = [];
  for (const event of events) {
    count++;
    const log = {
      data: event.data,
      topics: event.topics,
    };
    const newTokenid = BigInt(log.topics[1]).toString();
    const parent1Id = BigInt(log.topics[2]).toString();
    const parent2Id = BigInt(log.topics[3]).toString();
    // Récupération du bloc contenant l'événement
    const block = await provider.getBlock(event.blockNumber);

    // Récupération du timestamp du bloc
    const timestamp = block?.timestamp;

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

    // console.log(
    //   '//////////////////////////////////////////////////////////////////'
    // );

    // const { forgerId, mergerId } = event.args;

    // // Récupérer le bloc correspondant à l'événement
    // const block = await provider.getBlock(event.blockNumber);
    // const timestamp = block.timestamp;

    // console.log(`Past Event - Forger ID: ${forgerId.toString()}, Merger ID: ${mergerId.toString()}`);
    // console.log(`Block Timestamp: ${new Date(timestamp * 1000).toLocaleString()}`);
  }
  await migrateForgedPairsData(lowerIds, higherIds);
}

async function migrateForgedPairsData(lowerIds: string[], higherIds: string[]) {
  // Créez un wallet à partir d'une clé privée (ou utilisez un fournisseur Web3 comme Metamask)
  const signer = new ethers.Wallet('<YOUR_PRIVATE_KEY>', provider); // Remplacez par votre clé privée

  // Connecter le signer au contrat pour autoriser les transactions
  const contractWithSigner = newEntityForgingContract.connect(signer) as any;

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

// Appel pour récupérer les événements passés
fetchPastEvents();

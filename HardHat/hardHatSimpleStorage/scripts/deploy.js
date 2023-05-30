// imports
const { ethers, run, network } = require("hardhat");

// async main
async function main() {
  const SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage");
  console.log("Deploying contract...");
  const simpleStorage = await SimpleStorageFactory.deploy();
  await simpleStorage.deployed();
  console.log(`Deployed contract to: ${simpleStorage.address}`);
  if (process.env.ETHERSCAN_API_KEY) {
    console.log("Waiting for block confirmations...");
    // for for some blocks until verification
    await simpleStorage.deployTransaction.wait(5);
    await verify(simpleStorage.address, []);
  }

  const firstValue = await simpleStorage.retrieve();
  console.log(`The first Value is: ${firstValue}`);

  const transactionResponse = await simpleStorage.storeFav(7);
  await transactionResponse.wait(1);
  const updatedValue = await simpleStorage.retrieve();
  console.log(`Updated Value is: ${updatedValue}`);
}

// async function verify(contractAddress, args) {
const verify = async (contractAddress, args) => {
  console.log("Verifying contract...");
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    });
  } catch (e) {
    if (e.message.toLowerCase().includes("already verified")) {
      console.log("Already Verified!");
    } else {
      console.log(e);
    }
  }
};

// main
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// yarn hardhat run scripts/deploy.js --network sepolia

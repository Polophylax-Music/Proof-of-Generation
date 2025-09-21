const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deployer:", deployer.address);

  const PoG = await hre.ethers.getContractFactory("ProofOfGeneration");
  const pog = await PoG.deploy(deployer.address); // constructor: initialOwner
  await pog.waitForDeployment();

  const addr = await pog.getAddress();
  console.log("PoG deployed to:", addr);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});

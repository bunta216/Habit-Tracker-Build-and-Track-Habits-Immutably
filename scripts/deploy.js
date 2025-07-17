const hre = require("hardhat");

async function main() {
  const ZKResume = await hre.ethers.getContractFactory("ZKResume");
  const zkResume = await ZKResume.deploy();

  await zkResume.deployed();

  console.log("ZKResume deployed to:", zkResume.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

const hre = require("hardhat");

async function main() {


  const XUSDFaucet = await hre.ethers.getContractFactory("XusdFaucet");
  const xusdFaucet = await XUSDFaucet.deploy();

  await xusdFaucet.deployed();

  console.log(xusdFaucet.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

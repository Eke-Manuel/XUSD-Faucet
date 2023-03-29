const hre = require("hardhat");

async function main() {


  const XUSDFaucet = await hre.ethers.getContractFactory("XusdFaucet");
  const xusdFaucet = await XUSDFaucet.deploy("0xA3C957f5119eF3304c69dBB61d878798B3F239D9", "0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747");

  await xusdFaucet.deployed();

  console.log(xusdFaucet.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

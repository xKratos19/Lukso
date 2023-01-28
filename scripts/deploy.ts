import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  const name_ = "recycle";
  const symbol_ = "rec";
  const address_ = deployer.address;
  const adress2_ = "0x05cA25687CB1a20634d47C75AC28c7280E5789c5";
  const tag1 = "0x0000000000000000000000000000000000000000000000000000000000000001";
  const tag2 = "0x0000000000000000000000000000000000000000000000000000000000000002";

  console.log("Deploying contracts with the account:", deployer.address);

  const Recycle = await ethers.getContractFactory("Recycle");
  const recycle = await Recycle.deploy(
    name_,
    symbol_,
    address_
  );
  

  const mint = await recycle.generateManufacturer(deployer.address,"wool");
  console.log(await recycle.totalMinted());
  const mint2 = await recycle.generateManufacturer(deployer.address,"wool");
  console.log(await recycle.totalMinted());

  const check = await recycle.returnProductKey("2");
  console.log("Product Key:",await recycle.returnProductKey("2"));

  const check2= await recycle.returnProductCheck(check);

  console.log("Product Check: ",await recycle.returnProductCheck(check));

  const burnKey = await recycle.productKeyBurn(check);

  console.log("Address has:", await recycle.tagFinder(deployer.address));

  console.log("Id 1 it's owned by:", await recycle.tagIdFinder(tag1));

  console.log("Id 2 it's owned by:", await recycle.tagIdFinder(tag1));

  const burn = await recycle.tagBurn(tag1);

  

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

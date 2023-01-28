import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Recycle__factory } from "../typechain-types";

  describe("Minting", function () {
    it("Should deploy and log the total supply",async function(){
      const [deployer] = await ethers.getSigners();
      const name_ = "recycle";
      const symbol_ = "rec";
      const address_ = deployer.address;

    console.log("Deploying contracts with the account:", deployer.address);

    const Recycle = await ethers.getContractFactory("Recycle");
    const recycle = await Recycle.deploy(
      name_,
      symbol_,
      address_
    );
    await recycle.generateManufacturer(deployer.address,"wool");
    await expect(recycle.totalMinted).to.revertedWith("1");
    
    })

  });

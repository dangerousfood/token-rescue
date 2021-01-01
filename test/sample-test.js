const { expect } = require("chai");

describe("TokenRescue", function() {
  it("Test that the owner of TokenRescue is the deployer", async function() {
    const TokenRescue = await ethers.getContractFactory("TokenRescue");
    const tokeRescue = await TokenRescue.deploy();
    
    await tokeRescue.deployed();
    const accounts = await ethers.getSigners();
    expect(await tokeRescue.owner()).to.equal(accounts[0].address);
  });
});

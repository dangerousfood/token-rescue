const { expect } = require("chai");
const { accounts, contract } = require('@openzeppelin/test-environment');

const {
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

describe("TokenRescue", function() {
  const [ownerAddr, sender, receiver] = accounts;
  const value = "1000000000000000000";

  beforeEach(async function() {
    const [owner] = await ethers.getSigners();
    this.owner = owner

    const Example = await ethers.getContractFactory("Example");
    this.example = await Example.connect(this.owner).deploy();
    await this.example.deployed();

    const TestToken = await ethers.getContractFactory("TestToken");
    this.testToken = await TestToken.deploy();
    await this.testToken.deployed();
  });

  it("Test that the address that inherits TokenRescue is not the token interacted with", async function() {
    await this.example.mint(this.example.address, value)

    await expectRevert(
      this.example.rTransfer(this.example.address, receiver, value),
      'VM Exception while processing transaction: revert token address that inherits TokenRescue cannot be interacted with',
    );
  });

  it("Test that to ensure an address on the restricted list does not succeed", async function() {
    await this.example.addRestricted(this.testToken.address)
    await this.testToken.mint(this.example.address, value)

    await expectRevert(
      this.example.rTransfer(this.testToken.address, receiver, value),
      'VM Exception while processing transaction: revert token address provided is on the restricted list',
    );
  });

  it("Test that only the contract owner can call the rERC20 methods", async function() {
    await this.testToken.mint(this.example.address, value)

    await expectRevert(
      this.example.connect(receiver).rTransfer(this.testToken.address, receiver, value),
      'VoidSigner cannot sign transactions (operation="signTransaction", code=UNSUPPORTED_OPERATION, version=abstract-signer/5.0.9)',
    );
  });

  it("Successfully transfer using rTransfer method", async function() {
    await this.testToken.mint(this.example.address, value)
    const receipt = await this.example.connect(this.owner).rTransfer(this.testToken.address, receiver, value)
    
    // Event assertions can verify that the arguments are the expected ones
    expectEvent(receipt, 'Transfer', {
      from: this.example.address,
      to: receiver,
      value: value,
    });
  });
});


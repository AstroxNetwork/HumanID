const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("POP", function () {
  async function set_up() {
    const [owner, otherUser1, otherUser2] = await ethers.getSigners();

    const POP = await ethers.getContractFactory("POP");
    const pop = await POP.deploy();

    return { pop, owner, otherUser1, otherUser2 };
  }

  describe("deployment", function () {
    it("should set the right owner", async function () {
      const { pop, owner } = await loadFixture(set_up);

      expect(await pop.owner()).to.equal(owner.address);
    });
  });

  describe("add_authorize_address", function () {
    describe("validations", function () {
      it("should reject the method call", async function () {
        const { pop, otherUser1, otherUser2 } = await loadFixture(set_up);
        await expect(pop.connect(otherUser1).add_authorize_address(otherUser2.address)).to.be.revertedWith("only owner can call this method");
      })
    });
  });

  describe("detect_batch_start", function () {
    describe("validations", function () {

    });

    describe("return movements", function () {
      it("should return three moventments", async function () {
        const { pop } = await loadFixture(set_up);

        let movements = await pop.detect_batch_start();

        for (var i = 0; i < movements.length; i++) {
          expect(movements[i] > 0 && movements[i] < 4)
        }
      });
    });
  });

  describe("detect_batch_end", function () {
    describe("validations", function () {
      it("should reject the method call", async function () {
        const { pop, otherUser1, otherUser2 } = await loadFixture(set_up);
        await expect(pop.connect(otherUser1).detect_batch_end("test_site", otherUser2.address)).to.be.revertedWith("only authorized address can call this method");
      })
    });

    describe("create token", function () {
      it("should return token", async function () {
        const { pop, otherUser1, otherUser2 } = await loadFixture(set_up);

        pop.add_authorize_address(otherUser1.address)

        let token_1 = await pop.connect(otherUser1).get_token("test_site", otherUser2.address);
        expect(token_1.created_at).to.equal(0)

        await pop.connect(otherUser1).detect_batch_end("test_site", otherUser2.address);

        let token_2 = await pop.connect(otherUser1).get_token("test_site", otherUser2.address);
        expect(token_2.created_at).not.to.equal(0)

        let token_3 = await pop.connect(otherUser1).get_token("other_test_site", otherUser2.address);
        expect(token_3.created_at).to.equal(0)
      });
    });
  });
});

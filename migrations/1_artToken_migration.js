const Migrations = artifacts.require("ArtToken");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};

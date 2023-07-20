const { ethers } = require("hardhat");

async function main() {
  const Voting = await ethers.getContractFactory("Voting");
  const candidateNames = ["Candidate A", "Candidate B", "Candidate C"]; // names of initial candidates here
  const durationInMinutes = 30; // Set the duration of the voting process in minutes

  // Deploy the Voting contract to the "mumbai" network (Polygon's Mumbai testnet)
  const voting = await Voting.deploy(candidateNames, durationInMinutes);
  await voting.deployed();

  console.log("Voting contract deployed to:", voting.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

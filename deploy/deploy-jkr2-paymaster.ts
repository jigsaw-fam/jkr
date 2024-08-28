import { utils, Wallet } from "zksync-ethers";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync";
import * as dotenv from "dotenv"
 
// An example of a deploy script that will deploy and call a simple contract.
export default async function (hre: HardhatRuntimeEnvironment) {
  console.log(`Running deploy script`);
 
  // Initialize the wallet.
  dotenv.config()
  const { PRIVATE_KEY } = process.env
  const wallet = new Wallet(PRIVATE_KEY);
 
  // Create deployer object and load the artifact of the contract we want to deploy.
  const deployer = new Deployer(hre, wallet);
  // Load contract
  const artifact = await deployer.loadArtifact("contracts/JKRPaymaster.sol:JKRPaymaster");
 
  // Deploy this contract. The returned object will be of a `Contract` type,
  // similar to the ones in `ethers`.
  const tokenContract = await deployer.deploy(artifact, [ "0x530119B9BbE6e84a46FDa3d507E619Ec2EA3FBfF" ]);
 
  // Show the contract info.
  console.log(`${artifact.contractName} was deployed to ${await tokenContract.getAddress()}`);
}

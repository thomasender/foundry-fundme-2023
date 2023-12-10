// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

// Price Feed Contract Matic / USD Polygon
// Mainnet: 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
// Mumbai Testnet: 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        vm.startBroadcast();
        FundMe fundMe = new FundMe(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);
        vm.stopBroadcast();
        return fundMe;
    }
}

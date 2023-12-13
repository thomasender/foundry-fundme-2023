// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

// Price Feed Contract Matic / USD Polygon
// Mainnet: 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
// Mumbai Testnet: 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // Putting this before startBroadcast, because we don't want to broadcast this
        // broadcasting would cost gas, and we don't want to pay for it
        HelperConfig helperConfig = new HelperConfig();
        address maticUsdPriceFeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        // Everything from here on is a real transaction and costs gas!
        // https://docs.chain.link/data-feeds/price-feeds/addresses
        FundMe fundMe = new FundMe(maticUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}

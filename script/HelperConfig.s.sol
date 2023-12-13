// SPDX-License-Identifier: MIT

// 1. Deploy Mocks for working with local anvil chain
// 2. Keep track of contract adresses across different chains
// Sepolia ETH / USD
// Mumbai ETH / USD
// Polygon Mainnet ETH / USD

pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If on local anvil deploy mocks
    // Else use existing addresses from live networks

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 1e8;

    struct NetworkConfig {
        address priceFeed; // ETH / USD price feed address
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 137) {
            activeNetworkConfig = getPolygonEthConfig();
        } else if (block.chainid == 80001) {
            activeNetworkConfig = getMumbaiEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getMumbaiEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory mumbaiConfig = NetworkConfig({
            // https://docs.chain.link/data-feeds/price-feeds/addresses?network=polygon&page=1
            priceFeed: 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada
        });
        return mumbaiConfig;
    }

    function getPolygonEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory polygonConfig = NetworkConfig({
            // https://docs.chain.link/data-feeds/price-feeds/addresses?network=polygon&page=1&search=ETH+%2F+USD
            priceFeed: 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
        });
        return polygonConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // Do not deploy mock if already deployed
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        // price feed address
        // 1. Deploy the mock price feed
        // 2. return the mock price feed address

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}

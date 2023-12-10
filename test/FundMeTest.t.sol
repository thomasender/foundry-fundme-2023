// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

// Price Feed Contract Matic / USD Polygon
// Mainnet: 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
// Mumbai Testnet: 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimiumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        //
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsCorrect() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}

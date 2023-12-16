// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

// Price Feed Contract Matic / USD Polygon
// Mainnet: 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
// Mumbai Testnet: 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada

contract InteractionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant STARTING_BALANCE = 100e18;
    uint256 constant SUFFICIENT_AMOUNT = 5e18;
    uint256 constant INSUFFICIENT_AMOUNT = 1e18;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        // Withdraw
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}

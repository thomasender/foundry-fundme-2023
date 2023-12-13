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

    address USER = makeAddr("user");
    uint256 constant STARTING_BALANCE = 100e18;
    uint256 constant SUFFICIENT_AMOUNT = 5e18;
    uint256 constant INSUFFICIENT_AMOUNT = 1e18;

    // setUp is called before each test!
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimiumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        //
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsCorrect() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughValue() public {
        vm.expectRevert();
        fundMe.fund{value: INSUFFICIENT_AMOUNT}();
    }

    modifier funded() {
        vm.prank(USER);
        uint256 maticAmout = 5e18;
        fundMe.fund{value: SUFFICIENT_AMOUNT}();
        _;
    }

    function testFundUpdatesS_AddressToAmountFundedCorrectly() public funded {
        assertEq(fundMe.getAddressToAmountFunded(USER), SUFFICIENT_AMOUNT);
    }

    function testAddsFunderToFundersArray() public funded {
        assertEq(fundMe.getFunders().length, 1);
        assertEq(fundMe.getFunder(0), USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        // expect next transaction to revert
        vm.expectRevert();
        // send next transaction from USER
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        // The next transaction is sent by the owner
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        // Assert
        assertEq(
            fundMe.getOwner().balance,
            startingOwnerBalance + startingFundMeBalance
        );
        assertEq(address(fundMe).balance, 0);
    }

    function testWithdrawFromMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(uint160(i)), SUFFICIENT_AMOUNT);
            fundMe.fund{value: SUFFICIENT_AMOUNT}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        assert(
            fundMe.getOwner().balance ==
                startingOwnerBalance + startingFundMeBalance
        );
        assert(address(fundMe).balance == 0);
    }

    function testSetsOwnerCorrectly() public {
        assertEq(fundMe.getOwner(), DEFAULT_SENDER);
    }
}

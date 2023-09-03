// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {RebelsRevolt} from "../src/RebelsRevolt.sol";
import {StdCheats} from "forge-std/StdCheats.sol";



contract RRTest is StdCheats, Test {
    uint256 BOB_STARTING_AMOUNT = 100 ether;

    RebelsRevolt public rebelsRevolt;
    address public deployerAddress;
    address bob;
    address alice;
    uint256 MAX_SUPPLY = 1861933694 ether;
     

    function setUp() public {
        deployerAddress = vm.addr(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        vm.prank(deployerAddress);
        rebelsRevolt = new RebelsRevolt();


        bob = makeAddr("bob");
        alice = makeAddr("alice");

        
        vm.prank(deployerAddress);
        rebelsRevolt.transfer(bob, BOB_STARTING_AMOUNT);
    }
    
    
    function testMaxSupply() public {
        assertEq(rebelsRevolt.totalSupply(), MAX_SUPPLY);
    }
    
     function testTokenName () public {
        string memory token = "REBELS REVOLT";
        assertEq(token, rebelsRevolt.name());
    }

    function testTokenSymbol () public {
        string memory token = "$RBLS";
        assertEq(token, rebelsRevolt.symbol());
    }


    function testTokenDecimals () public {

        assertEq(18, rebelsRevolt.decimals());
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Alice approves Bob to spend tokens on her behalf
        vm.prank(bob);
        rebelsRevolt.approve(alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(alice);
        rebelsRevolt.transferFrom(bob, alice, transferAmount);
        assertEq(rebelsRevolt.balanceOf(alice), transferAmount);
        assertEq(rebelsRevolt.balanceOf(bob), BOB_STARTING_AMOUNT - transferAmount);
    }
    
    function testTransfer() public {
        uint256 initialBalance = BOB_STARTING_AMOUNT;
        uint256 transferAmount = 100;
        vm.prank(bob);
        rebelsRevolt.transfer(alice, transferAmount);

        uint256 finalBalance = rebelsRevolt.balanceOf(bob);

        assertEq(finalBalance, initialBalance - transferAmount);
        assertEq(rebelsRevolt.balanceOf(alice), transferAmount);
    }

    function testTransferFrom() public {
        address from = bob;
        address to = address(0x1);
        address spender = alice;
        uint256 allowanceAmount = 500;
        uint256 transferAmount = 100;
        vm.prank(from);
        rebelsRevolt.approve(spender, allowanceAmount);
        vm.prank(spender);
        rebelsRevolt.transferFrom(from, to, transferAmount);

        uint256 fromBalance = rebelsRevolt.balanceOf(from);
        uint256 toBalance = rebelsRevolt.balanceOf(to);

        assertEq(fromBalance, BOB_STARTING_AMOUNT - transferAmount);
        assertEq(toBalance, transferAmount);
    }


    function testDecreaseAllowance() public {
        address owner = bob;
        address spender = alice;
        uint256 allowanceAmount = 500;
        uint256 decreaseAmount = 200;
        
        vm.startPrank(owner);
        rebelsRevolt.approve(spender, allowanceAmount);
        rebelsRevolt.decreaseAllowance(spender, decreaseAmount);
        vm.stopPrank();

        uint256 allowance = rebelsRevolt.allowance(owner, spender);

        assertEq(allowance, allowanceAmount - decreaseAmount);
    }

    function testIncreaseAllowance() public {
        address owner = bob;
        address spender = alice;
        uint256 allowanceAmount = 500;
        uint256 increaseAmount = 200;
        vm.startPrank(owner);
        rebelsRevolt.approve(spender, allowanceAmount);
        rebelsRevolt.increaseAllowance(spender, increaseAmount);
        vm.stopPrank();

        uint256 allowance = rebelsRevolt.allowance(owner, spender);

        assertEq(allowance, allowanceAmount + increaseAmount);
    }

    function testOwnerAddress() public {
        assertEq(rebelsRevolt.owner(), deployerAddress);    
        }

    function testTransferOwnershipOwner () public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.transferOwnership(bob);
        address newOwner = rebelsRevolt.owner();
        assertEq(bob, newOwner);
    } 

    function testTransferOwnershipPublic() public {
        vm.prank(bob);
        vm.expectRevert();
        rebelsRevolt.transferOwnership(alice);
    }   


    function testTransferFromWithoutApproval () public {
        vm.prank(alice);
        vm.expectRevert();
        rebelsRevolt.transferFrom(bob, alice, 10 ether);
    }

    function testTransferFromZeroAddress() public {
        vm.prank(alice);
        vm.expectRevert();
        rebelsRevolt.transferFrom(address(0), alice, 0);
    }

    function testBalanceWorks() public {
        uint256 bobBalance = rebelsRevolt.balanceOf(bob);
        uint256 aliceBalance = rebelsRevolt.balanceOf(alice);
        assertEq(BOB_STARTING_AMOUNT, bobBalance);
        assertEq(aliceBalance, 0);
    }

    function testTransferToZeroAddress() public {
        vm.prank(bob);
        vm.expectRevert();
        rebelsRevolt.transfer(address(0), 10 ether);
    }

    function testTransferfromZeroAddress() public {
        vm.prank(address(0));
        vm.expectRevert();
        rebelsRevolt.transfer(alice, 10);
    }

    function testNotEnoughBalance () public {
        vm.prank(bob);
        vm.expectRevert();
        rebelsRevolt.transfer(alice, 1000 ether);
    }

    function testApprovalToZeroAddress() public {
        vm.prank(bob);
        vm.expectRevert();
        rebelsRevolt.approve(address(0), 100 ether);
    }
    function testIncreaseAllowaceToZeroAddress() public {
        vm.prank(bob);
        vm.expectRevert();
        rebelsRevolt.increaseAllowance(address(0), 100 ether);
    }
    function testDecreaseAllowaceToZeroAddress() public {
        vm.prank(bob);
        vm.expectRevert();
        rebelsRevolt.decreaseAllowance(address(0), 100 ether);
    }

    function testDecreaseAllowanceIfAllowanceIsAlreadyZero() public {
        vm.prank(bob);
        vm.expectRevert();
        rebelsRevolt.decreaseAllowance(alice, 100);
    }

    function testIncreaseAllowaceWhenAllowanceIsAlreadyZero() public {
        vm.prank(bob);
        rebelsRevolt.increaseAllowance(alice, 100);
        uint256 amount = rebelsRevolt.allowance(bob, alice);
        assertEq(amount, 100);

    }

    function testZeroTransfer() public {
        vm.prank(bob);
        rebelsRevolt.transfer(alice, 0);
        assertEq(0, rebelsRevolt.balanceOf(alice));
    }

    function testTransferOwnershipToZeroAddress() public {
        vm.prank(deployerAddress);
        vm.expectRevert();
        rebelsRevolt.transferOwnership(address(0));
    }

    function testRenounceOwnerhsipOwner () public {
        vm.prank(deployerAddress);
        rebelsRevolt.renounceOwnership();
        assertEq(rebelsRevolt.owner(), address(0));
    }

    function testRenounceInLoop () public {
         vm.prank(deployerAddress);
         rebelsRevolt.renounceOwnership();
         vm.expectRevert();
         rebelsRevolt.renounceOwnership();
        
    }

    function testRenounceOwnerhshipPublic() public {
        vm.prank(bob);
        vm.expectRevert();
        rebelsRevolt.renounceOwnership();
    }

    
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {PresaleVesting} from "../src/PresaleVesting.sol";
import {RebelsRevolt} from "../src/RebelsRevolt.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract PresaleVestingTest is Test {
    PresaleVesting public presaleVesting;
    RebelsRevolt public rebelsRevolt;
    address public token;
    
    address public deployerAddress;
    address bob;
    address alice;
    uint256 MAX_SUPPLY = 1861933694 ether;
    uint256 BOB_STARTING_AMOUNT = 100 ether;
    function setUp() public {
         deployerAddress = vm.addr(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        vm.startPrank(deployerAddress);
        rebelsRevolt = new RebelsRevolt();
        token = address(rebelsRevolt);
        presaleVesting = new PresaleVesting(token);
       

        bob = makeAddr("bob");
        alice = makeAddr("alice");
        rebelsRevolt.transfer(bob, BOB_STARTING_AMOUNT);
         vm.stopPrank();
    }

    ///////////////Presale Test//////////////////////
    
    ///@dev test vesting addition by the owner
    /// check if tokens sent to contract
    /// check if user vesting param are set correctly
    function testAddVestingOwner () public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
        uint256 initialOwnerBalance = rebelsRevolt.balanceOf(deployerAddress);
        vm.warp(1693718972);
        presaleVesting.addVesting (alice, 100 ether);
        vm.stopPrank();
        uint256 ownerFinalBalance = initialOwnerBalance - 100 ether;
        assertEq(ownerFinalBalance + 100 ether, initialOwnerBalance);
        assertEq(100 ether, rebelsRevolt.balanceOf(address(presaleVesting)));
        (uint256 total, uint256 vested, uint256 initial, uint256 totalClaimed, uint256 vestStart, uint256 vestEnd, bool claimed) = presaleVesting.users(alice);
        assertEq(total, 100 ether);
        assertEq (vested ,75 ether);
        assertEq (initial, 25 ether);
        assertEq (totalClaimed, 0);
        assertEq (vestStart, 1693718972 + 30 days);
        assertEq (vestEnd, 1693718972 + 30 days + 180 days);
        assertEq (claimed, false);

    }

    
    ///@dev test add vesting function when address input is zero
    function testAddVestingOwnerWhenAddressIsZero() public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
        vm.expectRevert();
        presaleVesting.addVesting (address(0), 100 ether);
    }
    

    ///@dev test add vesting function when amount is zero
    function testAddVestingOwnerWhenAmountIsZero() public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
        vm.expectRevert();
        presaleVesting.addVesting (alice, 0 ether);
    }

    ///@dev test vesting addition by the owner when he did not approved tokens 
    function testAddVestingOwnerWhenApprovalIsZero () public {
        vm.startPrank(deployerAddress);
        vm.expectRevert();
        presaleVesting.addVesting(alice, 1);
    }
    
    /// @dev test vesting addition when user already has vesting
    function testAddVestingWhenUserHasVestingAlready() public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),1000 ether );
        vm.warp(1693718972);
        presaleVesting.addVesting (alice, 100 ether);
        vm.expectRevert();
        presaleVesting.addVesting(alice, 100 ether);
        vm.stopPrank();
    }
    
    /// @dev test when other than owner try to call add vesting
    function testAddVestingPublic () public {
        vm.startPrank(bob);
        vm.expectRevert();
        presaleVesting.addVesting(alice, 1);
    }
    
    ///@dev test add multiple vesting with different array length (by owner)
    function testAddMultipleVestingArrayMismatch() public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
    
         address[] memory users = new address[](2);
         uint256[] memory amounts = new uint256[](1);

        users[0] = alice;
        amounts[0] = 1 ether;

        users[1] = bob;
        

         vm.expectRevert();
        presaleVesting.addVestingMultiple(users, amounts);
    }
    
    ///@dev test addVestingMultiple  when one of the amount is zero
    function testAddMultipleVestingZeroAmount() public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
       
         address[] memory users = new address[](2);
         uint256[] memory amounts = new uint256[](2);

        users[0] = alice;
        amounts[0] = 0;

        users[1] = bob;
        amounts[1] = 2 ether;

         vm.expectRevert();
        presaleVesting.addVestingMultiple(users, amounts);
    }
    
    ///@dev test add multiple vesting when one of user has vesting already
    function testAddMultipleVestingWhenOneOfTheUserHasVestingAlready() public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
       
         address[] memory users = new address[](2);
         uint256[] memory amounts = new uint256[](2);

        users[0] = alice;
        amounts[0] = 1 ether;

        users[1] = bob;
        amounts[1] = 2 ether;
        vm.warp(1693718972);
        presaleVesting.addVesting(alice, 1 ether);
         vm.expectRevert();
        presaleVesting.addVestingMultiple(users, amounts);
    }
    
    /// @dev test claim by zero address
    function testClaimAddressZero() public {
        vm.prank(address(0));
        vm.expectRevert();
        presaleVesting.claim();
    }
    
    /// @dev check claim Reentrancy Status to get more tokens than expected
    function testClaimReentrancyStatus() public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
        vm.warp(1693718972);
        presaleVesting.addVesting (alice, 100 ether);
        vm.stopPrank();
        vm.startPrank(alice);
        vm.warp(1693718972 + 250 days);
        presaleVesting.claim();
        vm.expectRevert();
        presaleVesting.claim();
        
        vm.stopPrank();
    }

    
    /// @dev test add vesting multipel when one of the address is zero
    function testAddMultipleVestingZeroAddress() public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
         address[] memory users = new address[](2);
         uint256[] memory amounts = new uint256[](2);

        users[0] = address(0);
        amounts[0] = 1 ether;

        users[1] = bob;
        amounts[1] = 2 ether;
        vm.expectRevert();

        presaleVesting.addVestingMultiple(users, amounts);
    }
    
    /// @dev test add mutliple vesting  (by owner)
    function testAddMultipleVestingOwner() public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
         address[] memory users = new address[](2);
         uint256[] memory amounts = new uint256[](2);

        users[0] = alice;
        amounts[0] = 1 ether;

        users[1] = bob;
        amounts[1] = 2 ether;

        vm.warp(1693718972);
        presaleVesting.addVestingMultiple(users, amounts);
        (uint256 total, uint256 vested, uint256 initial, uint256 totalClaimed, uint256 vestStart, uint256 vestEnd, bool claimed) = presaleVesting.users(alice);
        (uint256 totalb, uint256 vestedb, uint256 initialb, uint256 totalClaimedb, uint256 vestStartb, uint256 vestEndb, bool claimedb) = presaleVesting.users(bob);
        assertEq (total, 1 ether);
        assertEq (vested, 0.75 ether);
        assertEq (initial, 0.25 ether);
        assertEq (totalClaimed, 0);
        assertEq (vestStart, 1693718972 + 30 days);
        assertEq (vestEnd, 1693718972 + 30 days + 180 days);
        assertEq (claimed, false);

         assertEq (totalb, 2 ether);
        assertEq (vestedb, 1.5 ether);
        assertEq (initialb, 0.5 ether);
        assertEq (totalClaimedb, 0);
        assertEq (vestStartb, 1693718972 + 30 days);
        assertEq (vestEndb, 1693718972 + 30 days + 180 days);
        assertEq (claimedb, false);

        assertEq (3 ether, rebelsRevolt.balanceOf(address(presaleVesting)));


    }
   
    /// @dev function test add multiple vesting (by other than owner)
    function testAddMultipleVestingPublic() public {
        vm.prank(deployerAddress);
        rebelsRevolt.transfer(bob, 10 ether);
        vm.startPrank(bob);
        rebelsRevolt.approve(address(presaleVesting), 10 ether);
         address[] memory users = new address[](2);
         uint256[] memory amounts = new uint256[](2);

        users[0] = alice;
        amounts[0] = 1 ether;

        users[1] = bob;
        amounts[1] = 2 ether;

        vm.expectRevert();
        presaleVesting.addVestingMultiple(users, amounts);
    }
    
    /// @dev test owner address
    function testOwnerAddress() public {
        assertEq(presaleVesting.owner(), deployerAddress);    
        }
     
     /// @dev test trasnferownerhship
    function testTransferOwnershipOwner () public {
        vm.prank(deployerAddress);
        presaleVesting.transferOwnership(bob);
        address newOwner = presaleVesting.owner();
        assertEq(bob, newOwner);
    } 
    
    /// @dev test transfer ownerhship (by other than owner)
    function testTransferOwnershipPublic() public {
        vm.prank(bob);
        vm.expectRevert();
        presaleVesting.transferOwnership(alice);
    } 
    
    /// @dev test transfer ownerhsip to zero
    function testTransferOwnershipToZeroAddressByOwner() public {
        vm.prank(deployerAddress);
        vm.expectRevert();
        presaleVesting.transferOwnership(address(0));
    }
    
    /// @dev test renounce ownership (by owner)
    function testRenounceOwnerhsipOwner () public {
        vm.prank(deployerAddress);
        presaleVesting.renounceOwnership();
        assertEq(presaleVesting.owner(), address(0));
    }
    
    /// @dev test renounce ownership in loop
    function testRenounceOwnerhsipOwnerRepeat() public {
        vm.prank(deployerAddress);
        presaleVesting.renounceOwnership();
        vm.expectRevert();
        presaleVesting.renounceOwnership();
    }
    
    /// @dev test renounce ownerhsip by other than owner
    function testRenounceOwnerhshipPublic() public {
        vm.prank(bob);
        vm.expectRevert();
        presaleVesting.renounceOwnership();
    }  
    
    /// @dev test claim initial amount
    function testClaimInitialAmount ()public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
        vm.warp(1693718972);
        presaleVesting.addVesting (alice, 100 ether);
        vm.stopPrank();
       
        (,,uint256 initialTokens,,,,) = presaleVesting.users(alice);
        
        vm.prank(alice);
        vm.warp(1693718972 + 10);
        presaleVesting.claim();
        (,,,,,, bool value) = presaleVesting.users(alice);
        uint256 aliceBalance = rebelsRevolt.balanceOf(alice);
        assertEq(value, true);
        assertEq(aliceBalance, initialTokens);
        
    }
    
    /// @dev test claim during cliff period
    function testClaimWhenItsCliffPeriod() public {
         vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
        vm.warp(1693718972);
        presaleVesting.addVesting (alice, 100 ether);
        vm.stopPrank();
       
        (,,uint256 initialTokens,,,,) = presaleVesting.users(alice);
        
        vm.prank(alice);
        vm.warp(1693718972 + 29 days);
        presaleVesting.claim();
        (,,,,,, bool value) = presaleVesting.users(alice);
        uint256 aliceBalance = rebelsRevolt.balanceOf(alice);
        assertEq(value, true);
        assertEq(aliceBalance, initialTokens);
    }
    
    /// @dev test claim during cliff period when initial amount is already claimed
    function testClaimDuringCliffWhenInitialAmountIsAlreadyClaimed () public {
         vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
        vm.warp(1693718972);
        presaleVesting.addVesting (alice, 100 ether);
        vm.stopPrank();
       
        (,,uint256 initialTokens,,,,) = presaleVesting.users(alice);
        
        vm.prank(alice);
        vm.warp(1693718972 + 29 days);
        presaleVesting.claim();
        (,,,,,, bool value) = presaleVesting.users(alice);
        uint256 aliceBalance = rebelsRevolt.balanceOf(alice);
        assertEq(value, true);
        assertEq(aliceBalance, initialTokens);
        vm.prank(alice);
        vm.warp(1693718975 + 29 days);
        presaleVesting.claim();
        assertEq(aliceBalance, initialTokens);

    }
    /// @dev test claim by non-beneficiary
    function testClaimNonUser () public {
        vm.prank(bob);
        vm.expectRevert();
        presaleVesting.claim();

    }
    
    /// @dev test claim within same block when owner add vesting for a user
    function testClaimWithinSameBlockWhenVestingAdded () public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting), 1000 ether);
        vm.warp(1693718972);
        presaleVesting.addVesting(alice, 1000 ether);
        vm.stopPrank();
        vm.warp(1693718972);
        vm.prank(alice);
        vm.expectRevert();
        presaleVesting.claim();
        
    }

     /// @dev test claim when cliff just end
    function testClaimWhenCliffPeriodJustEnds() public {
         vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting),100 ether );
        vm.warp(1693718972);
        presaleVesting.addVesting (alice, 100 ether);
        vm.stopPrank();
        
        vm.prank(alice);
        vm.warp(1693718971 + 30 days);
        presaleVesting.claim();
        (,,,uint256 claimed,,, bool value) = presaleVesting.users(alice);
        uint256 aliceBalance = rebelsRevolt.balanceOf(alice);
        assertEq(value, true);
        assertEq(aliceBalance, claimed);
    }
    
    /// @dev test claim after vesting ends
    function testClaimAfterVestingPeriodIsOver () public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting), 1000 ether);
        vm.warp(1693718972);
        presaleVesting.addVesting(alice, 1000 ether);
        vm.stopPrank();
        vm.warp(1693718972 + 210 days + 1);
        vm.prank(alice);
        presaleVesting.claim();
        assertEq(rebelsRevolt.balanceOf(alice), 1000 ether);

    }
    
    /// @dev test claim when user has already claimed his tokens
    function testClaimWhenUserHasAlreadyClaimedAllHisTokens () public {
         vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting), 1000 ether);
        vm.warp(1693718972);
        presaleVesting.addVesting(alice, 1000 ether);
        vm.stopPrank();
        vm.warp(1693718972 + 210 days + 1);
        vm.startPrank(alice);
        presaleVesting.claim();
        vm.expectRevert();
        presaleVesting.claim();
        
    }
    
    /// @dev test claim in the middle of vesting (means anytime b/w vesting duration)
    function testClaimInTheMiddleOfVesting () public {
         vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting), 1000 ether);
        vm.warp(1693718972);
        presaleVesting.addVesting(alice, 1000 ether);
        vm.stopPrank();
        vm.warp(1693718972 + 30 days + 60 days);
        vm.prank(alice);
        presaleVesting.claim();
        (,,,uint256 claimedAmount,,,) = presaleVesting.users(alice);
        assertEq(claimedAmount, rebelsRevolt.balanceOf(alice));

    }
    ///@dev test to claim rebels revolt token
    function testClaimOtherERC20OwnerWithNativeToken () public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.transfer(address(presaleVesting), 1000 ether);
        vm.expectRevert();
        presaleVesting.claimOtherERC20Tokens(address(rebelsRevolt));

    }
    
    /// @dev test claimOtherERC20 if input is address zero
     function testClaimOtherERC20OwnerWithZeroAddressAsInput() public {
         vm.startPrank(deployerAddress);
        vm.expectRevert();
        presaleVesting.claimOtherERC20Tokens(address(0));

    }

   
    
    /// @dev test if claim other erc20 is called by other than owner
    function testClaimOtherERC20Public () public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting), 1000 ether);
        vm.warp(1693718972);
        presaleVesting.addVesting(alice, 1000 ether);
        vm.stopPrank();
        vm.startPrank(alice);
        vm.expectRevert();
        presaleVesting.claimOtherERC20Tokens(address(rebelsRevolt));
        vm.stopPrank();

    }
    
    /// @dev test claim one month after the cliff period
    function testClaimOneMonthAfterCliff () public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting), 1000 ether);
        vm.warp(1693718972);
        presaleVesting.addVesting(alice, 1000 ether);
        vm.stopPrank();
        vm.startPrank(alice);
        vm.warp(1693718972 + 1 days);
        presaleVesting.claim();
        (,,,uint256 claimedAmount,,,bool claimed) = presaleVesting.users(alice);
        assertEq(claimedAmount, rebelsRevolt.balanceOf(alice));
        assertEq(claimed, true);
        vm.warp(1693718972 + 60 days + 1);
        presaleVesting.claim();
        (,,,uint256 claimedAmountOneMonthAfterCliff,,,) = presaleVesting.users(alice);
        assertEq(claimedAmountOneMonthAfterCliff, rebelsRevolt.balanceOf(alice));
        console2.log(claimedAmountOneMonthAfterCliff, rebelsRevolt.balanceOf(alice));
        
    }
    
    /// @dev test claim month by month to determine if user get his alloted amount
    function testClaimMonthByMonth () public {
        vm.startPrank(deployerAddress);
        rebelsRevolt.approve(address(presaleVesting), 1000 ether);
        vm.warp(1693718972);
        presaleVesting.addVesting(alice, 1000 ether);
        vm.stopPrank();
        vm.startPrank(alice);
        vm.warp(1693718972 + 1 days);
        presaleVesting.claim();
        (,,,uint256 totalclaimedAmount,,,bool claimed) = presaleVesting.users(alice);
        assertEq(totalclaimedAmount, rebelsRevolt.balanceOf(alice));
        assertEq(claimed, true);
        vm.warp(1693718972 + 60 days + 1);
        presaleVesting.claim();
        (,,,uint256 claimedAmountOneMonthAfterCliff,,,) = presaleVesting.users(alice);
        assertEq(claimedAmountOneMonthAfterCliff, rebelsRevolt.balanceOf(alice));
        vm.warp(1693718972 + 90 days + 1);
        presaleVesting.claim();
        (,,,uint256 claimedAmountSecondMonth,,,) = presaleVesting.users(alice);
        assertEq(claimedAmountSecondMonth, rebelsRevolt.balanceOf(alice));
         vm.warp(1693718972 + 120 days + 1);
        presaleVesting.claim();
        (,,,uint256 claimedAmountThirdMonth,,,) = presaleVesting.users(alice);
        assertEq(claimedAmountThirdMonth, rebelsRevolt.balanceOf(alice));
         vm.warp(1693718972 + 150 days + 1);
        presaleVesting.claim();
        (,,,uint256 claimedAmountFourthMonth,,,) = presaleVesting.users(alice);
         vm.warp(1693718972 + 180 days + 1);
         assertEq(claimedAmountFourthMonth, rebelsRevolt.balanceOf(alice));
        presaleVesting.claim();
        (,,,uint256 claimedAmountFifthMonth,,,) = presaleVesting.users(alice);
        assertEq(claimedAmountFifthMonth, rebelsRevolt.balanceOf(alice));
         vm.warp(1693718972 + 210 days + 1);
        presaleVesting.claim();
        (,,,uint256 claimedAmountSixthMonth,,,) = presaleVesting.users(alice);
        assertEq(claimedAmountSixthMonth, 1000 ether);
        assertEq(rebelsRevolt.balanceOf(alice), 1000 ether);

    }
    
    /// @dev check if global cliff matches
    function testGlobalCliff() public {
        uint256 expectedTime = 30 days;
        uint256 actualTime = presaleVesting.getGlobalCliffTime();
        assertEq(expectedTime, actualTime);
    }
    
    /// @dev check if global versting period matches
    function testGlobalVestingPeriod () public {
        uint256 expectedDuration = 180 days;
        uint256 actualDuration = presaleVesting.getGlobalVestingDuration();
        assertEq(expectedDuration, actualDuration);
    }
    
    /// @dev check if token address (rebelsRevolt) matches
    function testTokenAddress () public {
        assertEq(address(rebelsRevolt), presaleVesting.getTokenAddress());
    }
    
    /// @dev check if initial unlock percentage matches
    function testGlobalInitialUnlockPercentage () public {
        assertEq(25, presaleVesting.getInitialUnlock());
    }
    

    
}


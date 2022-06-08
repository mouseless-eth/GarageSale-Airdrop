// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "../src/GarageSale.sol";
import "openzeppelin-contracts/contracts/token/ERC721/utils/ERC721Holder.sol";

contract GarageSaleTest is Test, ERC721Holder {
  GarageSale garageSale;
  Vm public VM;

  function setUp() public {
    // setting up cheatcode
    VM = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    garageSale = new GarageSale();
  }

  function testContractOwner() public {
    assertEq(garageSale.owner(), address(this), "Owner is not contract owner");
  }

  function testFailContractOwner() public {
    assertEq(garageSale.owner(), address(0), "burn address should not be owner");
  }

  function testChangeClaimStatus() public {
    garageSale.enableClaim(true);
    assertEq(garageSale.claimActive(), true, "Claim status not changed");
  }

  function testNotOwnerChangeClaimStatus() public {
    VM.expectRevert(bytes("Ownable: caller is not the owner"));
    VM.prank(address(0));
    bytes memory callData = abi.encodeWithSignature("enableClaim(bool)", true);
    (bool status, ) = address(garageSale).call(callData);
    assertTrue(status, "expectedRevert: call did not revert");
    assertEq(garageSale.claimActive(), false, "Claim status not changed");
  }
}

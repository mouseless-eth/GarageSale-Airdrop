// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "forge-std/console.sol";
import "ERC721A/ERC721A.sol";

contract GarageSale is ERC721A, Ownable {
  // Addredd of HoboNFT
  address public hoboNFT = 0x6e0418050387C6C3d4Cd206d8b89788BBd432525;

  // "Private" Variables
  string private baseURI;

  // Public Variables
  bool public claimActive = false;

  // Keeping track of which NFTs have been claimed
  mapping(uint => bool) public isClaimed;

  // Contract set up
  constructor() ERC721A("Garage Sale", "GarageSale") {}

  /// @notice Function to claim garage sale
  /// @dev calculations of _ids is done offchain using 0x438b6300 
  /// @param _ids Array of token ids to claim
  function claim(uint256[] calldata _ids) external {
    require(claimActive, "Claim is not active.");

    uint256 numTokensClaimed;

    for (uint256 i; i < _ids.length; i++) {
        if (!isClaimed[_ids[i]]) {
            require(IERC721(hoboNFT).ownerOf(_ids[i]) == msg.sender, "You do not own this token.");
            isClaimed[_ids[i]] = true;
            numTokensClaimed++;
        }
    }

    _safeMint(msg.sender, numTokensClaimed);
  }

  /// @notice Function to change the contract's metadata
  /// @param baseURI_ New base URI
  function setBaseURI(string memory baseURI_) external onlyOwner {
    baseURI = baseURI_;
  }

  /// @notice Function to change the contract's metadata
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  /// @notice Set the claim status of the contract
  /// @param _claimActive status of the claim
  function enableClaim(bool _claimActive) external onlyOwner {
    console.log("Owner", msg.sender);
    claimActive = _claimActive;
  }
}

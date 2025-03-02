// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Event is ERC721, Ownable {
    error NoMoreTickets();

    uint256 public immutable date; // Unix timestamp in seconds
    string public location;
    uint256 public availability;
    uint256 public nextTokenId;
    address public organizer;
    bool public immutable isPriceCapSet;
    address public whiteListAddress;

    constructor(
        address minter,
        string memory _name,
        uint256 date_,
        string memory location_,
        address organizer_,
        bool _isPriceCapSet,
        address whiteListAddress_,
        uint256 availability_

    ) ERC721(_name, "") Ownable(minter) {
        date = date_;
        location = location_;
        availability = 10;
        organizer = organizer_;
        isPriceCapSet = _isPriceCapSet;
        availability = availability_;
        if (isPriceCapSet) {
            whiteListAddress = whiteListAddress_;
        }
    }

    function safeMint(address to) public onlyOwner {
        if (nextTokenId == availability) {
            revert NoMoreTickets();
        }
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override returns (address) {
        if(isPriceCapSet && msg.sender != owner() && whiteListAddress != to){
            revert("invalid transfer (price cap)");
        }
        return super._update(to, tokenId, auth);
    }
}

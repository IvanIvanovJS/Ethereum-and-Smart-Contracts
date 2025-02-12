// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract  digitalLibrary{
    struct EBook {
        string title;
        string author;
        uint256	publicationDate;
        uint256 expirationDate;
        string status;
        address primaryLibrarian;
        uint256 readCount;
          }
        EBook public digitalBook1;

        mapping (address => bool) public authorizedLibrerians;

    function digitalBook (string memory _title, string memory _author, uint256 _publicationDate, uint256 _expirationDate, string memory _status, address _primaryLibrarian, uint256 _readCount) public {
            require(digitalBook1.primaryLibrarian == address(0), "Ebook already set");
            digitalBook1 = EBook(_title, _author, _publicationDate, _expirationDate, _status, _primaryLibrarian, _readCount);
            authorizedLibrerians[_primaryLibrarian] = true;

    }
    

         
}
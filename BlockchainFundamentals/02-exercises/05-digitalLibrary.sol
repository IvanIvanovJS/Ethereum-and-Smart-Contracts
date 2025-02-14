// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;
import "@openzeppelin/contracts/utils/Strings.sol";

contract digitalLibrary {
    enum BookStatus {
        Active,
        Outdated,
        Archived
    }
    struct EBook {
        string title;
        string author;
        uint256 publicationDate;
        uint256 expirationDate;
        BookStatus status;
        address primaryLibrarian;
        uint256 readCount;
    }
    address public owner;
    mapping(address => bool) public authorizedLibrerians;
    mapping(bytes32 => EBook) public books;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
    modifier onlyLibrarian() {
        require(authorizedLibrerians[msg.sender], "Not authorized Labrarian");
        _;
    }

    constructor() {
        owner = msg.sender;
        authorizedLibrerians[msg.sender] = true;
    }

    function digitalBook(
        string memory _title,
        string memory _author,
        uint256 _expirationDays,
        BookStatus _status,
        uint256 _readCount
    ) public onlyLibrarian {
        require(_expirationDays > 0, "Invalid Expiration Days");
        bytes32 bookId = keccak256(abi.encodePacked(_title));
        books[bookId].title = _title;
        books[bookId].author = _author;
        books[bookId].publicationDate = block.timestamp;
        books[bookId].expirationDate = (books[bookId].publicationDate +
            (_expirationDays * 1 days));
        books[bookId].status = _status;
        books[bookId].readCount = _readCount;
        books[bookId].primaryLibrarian = msg.sender;
    }

    function getBookInfo(string memory _title) public returns (EBook memory) {
        require(
            bytes(books[keccak256(abi.encodePacked(_title))].title).length > 0,
            "Book doesn't exist"
        );
        require(
            books[keccak256(abi.encodePacked(_title))].expirationDate >
                block.timestamp,
            "This book has expired"
        );
        books[keccak256(abi.encodePacked(_title))].readCount += 1;
        return books[keccak256(abi.encodePacked(_title))];
    }

    function setAuthorizedLibrarians(string memory _title, address _address)
        public
    {
        bytes32 bookId = keccak256(abi.encodePacked(_title));
        require(
            books[bookId].primaryLibrarian == msg.sender,
            "Only primary librarian can add others"
        );
        authorizedLibrerians[_address] = true;
    }

    function readBookCount(string memory _title) public onlyLibrarian {
        require(
            bytes(books[keccak256(abi.encodePacked(_title))].title).length > 0,
            "Book doesn't exist"
        );
        require(
            books[keccak256(abi.encodePacked(_title))].expirationDate >
                block.timestamp,
            "This book has expired"
        );
        books[keccak256(abi.encodePacked(_title))].readCount += 1;
    }

    function extendExpirationDate(
        string memory _title,
        uint256 addExpirationDays
    ) public onlyLibrarian returns (string memory) {
        require(
            bytes(books[keccak256(abi.encodePacked(_title))].title).length > 0,
            "Book doesn't exist"
        );
        require(
            books[keccak256(abi.encodePacked(_title))].expirationDate >
                block.timestamp,
            "This book has expired"
        );
        books[keccak256(abi.encodePacked(_title))].expirationDate +=
            addExpirationDays *
            1 days;
        string memory bookTitle = books[keccak256(abi.encodePacked(_title))]
            .title;
        string memory extendDays = Strings.toString(addExpirationDays);
        return
            string(
                abi.encodePacked(
                    bookTitle,
                    " expiration extended by ",
                    extendDays,
                    " days"
                )
            );
    }

    function changeBookStatus(string memory _title, BookStatus _newStatus)
        public
        onlyLibrarian
        returns (BookStatus)
    {
        require(
            bytes(books[keccak256(abi.encodePacked(_title))].title).length > 0,
            "Book doesn't exist"
        );
        books[keccak256(abi.encodePacked(_title))].status = _newStatus;
        return books[keccak256(abi.encodePacked(_title))].status;
    }
}

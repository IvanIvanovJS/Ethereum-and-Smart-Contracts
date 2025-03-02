// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import "./Event.sol";

enum BuyingOptions {
    FixedPrice,
    Bidding
}

struct EventData {
    uint256 ticketPrice;
    BuyingOptions saleType;
    uint256 salesEnds; // unix timestamp
}

error InvalidInput(string info);
error AlreadyListed();
error NotEventOrganizer();
error WrongBuyingOptions();
error ProfitDistributionFailed();

contract Marketplace {
    mapping(address => EventData) public events;
    mapping(address => uint256) public profits;
    mapping(address => mapping(address => bool)) public secondMarketListings;

    uint256 public constant MIN_SALE_PERIOD = 1 days;
    uint256 public marketFee;
    address public immutable feeColector;

    event NewEvent(address indexed newEvent);

    constructor(address feeColector_) {
        feeColector = feeColector_;
    }

    function createEvent(
        string memory name,
        uint256 date,
        string memory location,
        uint256 ticketPrice,
        BuyingOptions saleType,
        uint256 saleEnds,
        bool _isPriceCapSet,
        address whiteListAddress_,
        uint256 availability_
    ) external {
        address newEvent = address(
            new Event(
                address(this),
                name,
                date,
                location,
                msg.sender,
                _isPriceCapSet,
                whiteListAddress_,
                availability_
            )
        );
        emit NewEvent(newEvent);
        _listEvents(newEvent, ticketPrice, saleType, saleEnds);
    }

    function listEvents(
        address newEvent,
        uint256 ticketPrice,
        BuyingOptions saleType,
        uint256 saleEnds
    ) external returns (address) {
        if (msg.sender != Event(newEvent).organizer()) {
            revert NotEventOrganizer();
        }
        _listEvents(newEvent, ticketPrice, saleType, saleEnds);
        return newEvent;
    }

    function _listEvents(
        address newEvent,
        uint256 ticketPrice,
        BuyingOptions saleType,
        uint256 saleEnds
    ) internal {
        if (saleEnds < block.timestamp + MIN_SALE_PERIOD) {
            revert InvalidInput("Minimum sale period one day in the future");
        }

        if (events[newEvent].salesEnds != 0) {
            revert AlreadyListed();
        }

        events[newEvent] = EventData({
            ticketPrice: ticketPrice,
            saleType: saleType,
            salesEnds: saleEnds
        });
    }

    function buyOnSecondMarket(
        address event_,
        uint256 ticketID,
        address owner
    ) external payable {
        if (events[event_].saleType != BuyingOptions.FixedPrice) {
            revert WrongBuyingOptions();
        }

        if (events[event_].ticketPrice != msg.value) {
            revert InvalidInput("send value incorrect");
        }
        marketFee = (events[event_].ticketPrice * 10) / 100;
        profits[Event(event_).organizer()] +=
            events[event_].ticketPrice -
            marketFee;
        profits[feeColector] += marketFee;

        Event(event_).safeTransferFrom(owner, msg.sender, ticketID);
    }

    function buyTicket(address from) external payable {
        if (events[from].saleType != BuyingOptions.FixedPrice) {
            revert WrongBuyingOptions();
        }

        if (events[from].ticketPrice != msg.value) {
            revert InvalidInput("send value incorrect");
        }
        marketFee = (events[from].ticketPrice * 10) / 100;
        profits[Event(from).organizer()] +=
            events[from].ticketPrice -
            marketFee;
        profits[feeColector] += marketFee;

        Event(from).safeMint(msg.sender);
    }

    function withdrawProfits(address to) external payable {
        uint256 profit = profits[msg.sender];
        profits[msg.sender] = 0;
        if (profit == 0) {
            revert InvalidInput("balance is zero");
        } else {
            (bool success, ) = to.call{value: profit}("");
            if (!success) {
                revert ProfitDistributionFailed();
            }
        }
    }
}

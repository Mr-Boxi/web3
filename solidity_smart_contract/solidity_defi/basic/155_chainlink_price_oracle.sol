// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract ChainlinkPriceOracle {
    AggregatorV3Interface internal priceFeed;

    constructor() {
        // eth / usd
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    }

    function getLatestPrice() public view returns (int) {
        (
            uint80 roundID,
            uint price,
            uint startedAt,
            uint timestamp,
            uint80 answerInRound
        ) = priceFeed.latestRoundData();
        return price / 1e8;
    }
}

interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns
    (
        uint80 roundId,
        int answer,
        uint starteAt,
        uint updateAt,
        uint80 answeredInRound
    );
}
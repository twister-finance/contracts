// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

interface cToken {
    function underlying() external view returns (address);
}

interface ChainLinkOracle{
    function latestAnswer() external view returns (int256);
}

abstract contract PriceOracle {
    /// @notice Indicator that this is a PriceOracle contract (for inspection)
    bool public constant isPriceOracle = true;

    /**
      * @notice Get the underlying price of a cToken asset
      * @param cToken The cToken to get the underlying price of
      * @return The underlying asset price mantissa (scaled by 1e18).
      *  Zero means the price is unavailable.
      */
    function getUnderlyingPrice(address cToken) virtual external view returns (uint);
}

contract cTokenLUSDPriceOracle is PriceOracle {
    uint256 internal constant CHAINLINK_PRICE_SCALE = 10;
    address constant LUSD_CHAINLINK_ORACLE = address(0x0411D28c94d85A36bC72Cb0f875dfA8371D8fFfF);
    
    // This oracle derives its prices from Chainlink
    // All prices are either mantissa with 18 decimals or 0 if stale price. 0 reverts on main contract
    function getUnderlyingPrice(address cTokenAddress) override external view returns (uint256) {
        cTokenAddress; // Not used here
        uint256 price = uint256(ChainLinkOracle(LUSD_CHAINLINK_ORACLE).latestAnswer()) * (10 ** CHAINLINK_PRICE_SCALE);
        return price;
    }
}
// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

interface cToken {
    function underlying() external view returns (address);
}

interface IERC20 {
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
}

interface HmxCalculator {
    function getAUME30(bool _isMaxPrice) external view returns (uint256);
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

contract cTokenHLPPriceOracle is PriceOracle {

    address constant HMX_CALCULATOR = address(0x0FdE910552977041Dc8c7ef652b5a07B40B9e006);
    
    // All prices are either mantissa with 18 decimals or 0 if stale price. 0 reverts on main contract
    function getUnderlyingPrice(address cTokenAddress) override external view returns (uint256) {
        address hlpAddress = cToken(cTokenAddress).underlying();
        uint256 totalSupply = IERC20(hlpAddress).totalSupply();
        uint256 aum = HmxCalculator(HMX_CALCULATOR).getAUME30(true);
        uint256 price = aum * 1e6 / totalSupply;
        return price;
    }
    
}
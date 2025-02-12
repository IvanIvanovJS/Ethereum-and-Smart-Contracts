// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;
/*This task involves building a temperature conversion contract that enables 
users to convert temperatures between Celsius and Fahrenheit.*/

contract temperatureConversion {
    function toFahrenheit(uint256 celsiusTemp) external pure returns (uint256){
        uint256 fahrenheit = (celsiusTemp * 9 / 5)  + 32 ;
       return  fahrenheit;

    }
    function toCelsius(uint256 fahrenheitTemp) external  pure returns (uint256){
        uint256 celsius = (fahrenheitTemp - 32) * 5 / 9;
        return celsius;
    }
}

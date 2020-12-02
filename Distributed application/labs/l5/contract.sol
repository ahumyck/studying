// SPDX-License-Identifier: RANDOM_TEXT
pragma solidity >= 0.4.21;
contract ValueKeeper {

    int public value = -1;

    function getValue() public view returns(int) {
        return value;
    }
    
    function setValue(int newValue) public {
        value = newValue;
    }
}
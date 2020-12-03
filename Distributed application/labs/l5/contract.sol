// SPDX-License-Identifier: RANDOM_TEXT
pragma solidity >= 0.4.21;
contract ValueKeeper {

    mapping (int => uint256) timestamps;
    mapping (int => int) values;    

    function getValue(int key) public view returns(int) {
        return values[key];
    }
    
    function tryUpdateValue(int key, int newValue) public {
        uint256 transactionTime = block.timestamp;
        if (timestamps[key] > 0) {
            require(transactionTime > timestamps[key] + 30 days , "More than 30 days has to pass by.");
        }
        timestamps[key] = transactionTime;
        values[key] = newValue;
    }
    
}
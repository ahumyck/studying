// SPDX-License-Identifier: RANDOM_TEXT
pragma solidity >= 0.4.21;
contract ValueKeeper {

    struct UserData {
        address userId;
        string name;
        string homeAddress;
    }

    mapping (address => UserData) data;
    mapping (address => uint256) timestamps;
    mapping (address => int) values;    

    function getValue(address _id) public view returns(int) {
        return values[_id];
    }
    
    function addUser(address _id, string memory _name, string memory _addr, int value) public {
        UserData memory user = UserData(_id, _name, _addr);
        timestamps[_id] = block.timestamp;
        values[_id] = value;
    }
    
    function tryUpdateValue(address _id, int newValue) public {
        uint256 transactionTime = block.timestamp;
        if (timestamps[_id] > 0) {
            require(transactionTime > timestamps[_id] + 5 seconds , "More than 30 days has to pass by.");
            /* 30 days */
        }
        timestamps[_id] = transactionTime;
        values[_id] = newValue;
    }
    
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract POP {
    
    struct Token {
      address user;
      string scope;
      uint created_at;
    }

    enum Movement {
      Blink, Mouth, Shake, Nod
    }
      
    mapping (address => mapping (string => Token)) private tokens;

    address public owner;

    mapping (address => uint) private authrozies;

    constructor() payable {
        owner = msg.sender;
    }

    function detect_batch_start() public view returns (Movement) {
      return Movement(randMod() % 4);
    }

    function detect_batch_end(string calldata scope, address user) public {
      require(authrozies[msg.sender] != 0, "only authorized address can call this method");
      tokens[user][scope] = Token(user, scope, block.timestamp);
    }

    function get_token(string calldata scope, address user) public view returns (Token memory) {
      return tokens[user][scope];
    }

    function add_authorize_address(address authrozie_address) public {
      require(owner == msg.sender, "only owner can call this method");
      authrozies[authrozie_address] = 1;
    }

    function randMod() internal view returns(uint){
      return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));
    }

    function deleteContract() external {
      require(owner == msg.sender, "only owner can call this method");
      selfdestruct(payable(owner));
    }
}

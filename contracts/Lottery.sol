pragma solidity ^0.4.22;

contract Lottery {
    // the owner of the contract's address
    address public manager;
    
    // dynamic array that can only contain addresses
    address[] public players;
    
    // function to get the address of the owner of the contract
    constructor() public {
        manager = msg.sender;
    }
    
    // function to enter into the lottery
    // players send ether - need to use payable to call a function and send money
    function enter() public payable {
        // this function requires person to send ether before function continues
        // if function evaluates false, function exists
        require(msg.value > .01 ether);
        
        // add players address
        players.push(msg.sender);
    }
    
    // private pseudo random number generator
    function random() private view returns(uint) {
        // calling the sha3 algorithm. sha3 is global
        // passing variables to it
        // block difficluty, now is a global time variables, players
        return uint(keccak256(block.difficulty, block.timestamp, players));
    }
    
    // pick a winner function by calling random number generator and then using it as an index for the player array
    function pickWinner() public restricted {
        // require the manager to call this function

        uint index = random() % players.length; // takes the random number and divides it by player length to get the remainder
        // transfer function attempts to send value to the players address
        // this.balance is the amount of money in the contract
        players[index].transfer(address(this).balance);
        
        // creates brand new dynamic address array with initial size of 0
        // pretty much resets the players array
        players = new address[](0);
    }
    
    // modifier for only manager can call function
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    function getPlayers() public view returns (address[]) {
        return players;
    }
    
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public participants; 

    constructor() {
        manager = msg.sender;  // The contract's address is given to the manager
    }

    receive() external payable {
        require(msg.value >= 1 ether);
        participants.push(payable(msg.sender)); 
}

    function getBalance() public view returns(uint){
        require(msg.sender == manager);  
        return address(this).balance;
    }

    //selecting particiapnts on random basis now!

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }
    // this random function generates a big number soo we have to shrten it to give 1 index and that index holder is the winner of lottery!

    function selectWinner() public{
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        //return winner;

        winner.transfer(getBalance());

         participants = new address payable[](0);   //reset the participants array!
    }
}
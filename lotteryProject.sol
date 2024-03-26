// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    //declaring the state variables

    address payable[] public players;
    address public manager;

    //declaring the constructor

    constructor() {
        manager = msg.sender; //initializing the owner to the address that deploys the contract
    }

    //declaring the receive function that is necessary to receive ETH

    receive() external payable {
        //each player sends exactly 0.1 ETH

        require(msg.value == 0.1 ether);

        //appending the player to the players array

        players.push(payable(msg.sender));
    }

    //returning the contract's balance in wei

    function getBalance() public view returns (uint256) {
        // only the manager is allowed to call it

        require(msg.sender == manager);
        return address(this).balance;
    }

    //helper function that returns a big random integer // NOT SECURE //

    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }

    //selecting the winner

    function pickWinner() public {
        // only the manager can pick a winner if there are at least 3 players in the lottery
        require(msg.sender == manager);
        require(players.length >= 3);

        uint256 r = random();

        address payable winner;

        uint256 index = r % players.length;
        winner = players[index];
        winner.transfer(getBalance());
        players = new address payable[](0); //resetting the lottery;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
  CoinFlip for Zenchain Testnet (ZTC)
  - Requires a minimum bet of 5 ZTC
  - Uses native ZTC (1 ZTC = 1 ether in wei terms)
  - Rejects bets if contract can't pay double
*/

contract CoinFlip {
    address public owner;
    uint256 public constant MIN_BET = 5 ether; // 5 ZTC in wei

    event BetPlaced(
        address indexed player,
        uint256 amount,
        bool guess,
        bool win,
        uint256 payout
    );

    constructor() {
        owner = msg.sender;
    }

    // Place a bet
    function flip(bool _guess) external payable {
        require(msg.value >= MIN_BET, "Bet must be at least 5 ZTC");

        // Require the pot (excluding this incoming bet) can cover the win
        require(
            address(this).balance - msg.value >= msg.value,
            "Contract has insufficient balance"
        );

        // Insecure randomness — for demo/testnet only
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.difficulty,
                    msg.sender
                )
            )
        );
        bool outcome = (random % 2 == 0);

        uint256 payout = 0;
        if (outcome == _guess) {
            payout = msg.value * 2;
            (bool sent, ) = payable(msg.sender).call{value: payout}("");
            require(sent, "Payout failed");
        }

        emit BetPlaced(msg.sender, msg.value, _guess, outcome == _guess, payout);
    }

    // Owner withdraw funds
    function withdraw(uint256 _amountWei) external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(address(this).balance >= _amountWei, "Insufficient balance");
        (bool sent, ) = payable(owner).call{value: _amountWei}("");
        require(sent, "Withdraw failed");
    }

    // Fund contract
    receive() external payable {}

    // View current contract balance (optional helper)
    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

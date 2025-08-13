// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
  Simple CoinFlip contract for Zenchain Testnet (ZTC).
  - Uses native chain currency (ZTC) for bets.
*/

contract CoinFlip {
    address public owner;
    uint256 public minBet; // in wei (1 ZTC = 10^18 wei conceptually)
    event BetPlaced(address indexed player, uint256 amount, bool guess, bool win, uint256 payout);

    constructor(uint256 _minBetWei) {
        owner = msg.sender;
        minBet = _minBetWei;
    }

    // Place a bet. _guess: true = heads, false = tails
    function flip(bool _guess) external payable {
        require(msg.value >= minBet, "Bet below minimum");

        // VERY INSECURE randomness: DO NOT USE ON MAINNET
        // For demo/testnet only. Replace with Chainlink VRF in production.
        uint256 random = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) ;
        bool outcome = (random % 2 == 0);

        uint256 payout = 0;
        if (outcome == _guess) {
            // winner: pays double (original wager returned + equal reward)
            payout = msg.value * 2;
            // Ensure contract has enough balance (in tests, fund contract or owner)
            // Use call to transfer to avoid gas limit issues
            (bool sent, ) = payable(msg.sender).call{value: payout}("");
            require(sent, "Payout failed");
        }

        emit BetPlaced(msg.sender, msg.value, _guess, outcome == _guess, payout);
    }

    // Owner withdraw funds from contract
    function withdraw(uint256 _amountWei) external {
        require(msg.sender == owner, "Only owner");
        require(address(this).balance >= _amountWei, "Insufficient balance");
        (bool sent, ) = payable(owner).call{value: _amountWei}("");
        require(sent, "Withdraw failed");
    }

    // Allow contract to receive funds (owner can fund with test ZTC)
    receive() external payable {}
}

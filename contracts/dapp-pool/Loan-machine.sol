// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StateMachine {
    enum State {
        PENDING,
        ACTIVE,
        CLOSED
    }
    State public state = State.PENDING;
    uint256 public amount;
    uint256 public interest;
    uint256 public end;
    uint256 public duration;
    address payable public borrower;
    address payable public lender;

    constructor(
        uint256 _amount,
        uint256 _interest,
        uint256 _duration,
        address payable _borrower,
        address payable _lender
    ) {
        amount = _amount;
        interest = _interest;
        duration = _duration;
        borrower = _borrower;
        lender = _lender;
    }

    function fund() external payable {
        require(msg.sender == lender, "only lender can lend");
        require(
            address(this).balance == amount,
            "can only lend the exact amount"
        );
        _transitionTo(State.ACTIVE);
        borrower.transfer(amount);
    }

    function reimburse() external payable {
        require(msg.sender == borrower, "only borrower can reimburse");
        require(
            msg.value == amount + interest,
            "borrower need to reimburse exactly amount + interest"
        );
        _transitionTo(State.CLOSED);
        lender.transfer(amount + interest);
    }

    function _transitionTo(State to) internal {
        require(to != State.PENDING, "cannot go back to pending");
        require(to != state, "cannot transition to same state");
        if (to == State.ACTIVE) {
            require(
                state == State.PENDING,
                "cannot only go to active from pending"
            );
            state = State.ACTIVE;
            end = block.timestamp + duration;
        }
        if (to == State.CLOSED) {
            require(
                state == State.ACTIVE,
                "cannot only go to closed from active"
            );
            require(block.timestamp >= end, "loan hasnt matured yet");
            state = State.CLOSED;
        }
    }
}

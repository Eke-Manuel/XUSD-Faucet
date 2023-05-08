// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract XusdFaucet is Ownable, ReentrancyGuard {

    IERC20 public XUSD;
    bool public open;

    struct Cache {
        uint256 totalAmountReceived;
        uint lastWithdrawTime;
    }

    mapping(address => Cache) public addressCache;

    constructor() {
        XUSD = IERC20(0xA3C957f5119eF3304c69dBB61d878798B3F239D9);
        openFaucet();
    }

    function getTestTokens(address payable _to) external nonReentrant onlyOwner {
        require(open, "faucet is closed");
        requireAmountAndTime(_to);
        addressCache[_to].totalAmountReceived += 10;
        addressCache[_to].lastWithdrawTime += block.timestamp;
        XUSD.transfer(
            _to,
            10e18
        );
        if (addressCache[msg.sender].totalAmountReceived == 0) {
             _to.transfer(5e17);
        }
    }

    function shutdownFaucet() external onlyOwner {
        open = false;
    }

    function openFaucet() public onlyOwner {
        open = true;
    }

    function requireAmountAndTime(address _to) private view {
        if (addressCache[_to].totalAmountReceived < 50) {
            uint timestamp = addressCache[_to].lastWithdrawTime;
            require(block.timestamp - timestamp >= 1 days, "less than 24hrs since last withdrawal");
        } else {
            revert("Max withdrawal reached");
        }

    }

    receive() external payable {

    }
}

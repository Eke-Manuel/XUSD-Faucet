// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract XusdFaucet is Ownable, ReentrancyGuard {

    IERC20 public XUSD;
    IERC20 public Matic;
    bool public open;

    struct Cache {
        uint256 totalAmountReceived;
        uint lastWithdrawTime;
    }

    mapping(address => Cache) public addressCache;

    constructor(address _xusd, address _matic) {
        require(_xusd != address(0), "invalid address");
        require(_matic != address(0), "invalid address");
        XUSD = IERC20(_xusd);
        Matic = IERC20(_matic);
        openFaucet();
    }

    function getTestTokens(address payable _to) external nonReentrant {
        require(open, "faucet is closed");
        requireAmountAndTime(_to);
        addressCache[_to].totalAmountReceived += 10;
        addressCache[_to].lastWithdrawTime += block.timestamp;
        XUSD.transferFrom(
            address(this),
            _to,
            10e18
        );
        if (addressCache[msg.sender].totalAmountReceived == 0) {
            Matic.transferFrom(
                address(this),
                _to,
                5e5
            );
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
}

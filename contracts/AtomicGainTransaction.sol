pragma solidity ^0.8.4;

import "./LoanModule.sol";

// Not the best name.

/// @title AtomicGainModule
/// @dev A simple Module to do trades etc. on behalf of a GnosisSafe, all transactions pass as long as we have equal to
///      or more of the assets lent at the end of the transaction.
/// @author Dialectic
contract AtomicGainModule is LoanModule {
    function execute(
        GnosisSafe safe,
        address[] calldata assets,
        uint256[] calldata amounts,
        address to,
        bytes calldata data
    ) external {
        require(amounts.length == assets.length, "Length does not match");

        uint256[] memory balances = new uint256[](amounts.length);
        for (uint256 i = 0; i < assets.length; i++) {
            balance[i] = ERC20(assets[i]).balanceOf(safe);
            transfer(safe, msg.sender, assets[i], amounts[i]);
        }

        AtomicGainModule(to).flash(safe, assets, amounts, data);

        for (uint256 i = 0; i < assets.length; i++) {
            require(ERC20(assets[i]).balanceOf(safe) >= balances[i]);
        }
    }
}

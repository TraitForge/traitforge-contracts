// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ITrait } from "./interfaces/ITrait.sol";
import { IUniswapV2Router01, IUniswapV2Router02 } from "./interfaces/IUniswapV2Router.sol";
import { AddressProviderResolver } from "contracts/core/AddressProviderResolver.sol";

contract DAOFund is AddressProviderResolver {
    //   Imports
    //   Type declarations

    // Events

    // Modifiers

    // State variables
    IUniswapV2Router01 public uniswapV2Router;

    constructor(address _router, address _addressProvider) AddressProviderResolver(_addressProvider) {
        uniswapV2Router = IUniswapV2Router02(_router);
    }

    receive() external payable {
        require(msg.value > 0, "No ETH sent");

        ITrait traitToken = _getTraitToken();
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = address(traitToken);

        uniswapV2Router.swapExactETHForTokens{ value: msg.value }(0, path, address(this), block.timestamp);

        require(traitToken.burn(traitToken.balanceOf(address(this))) == true, "Token burn failed");
    }

    /**
     * internal & private *******************************************
     */
    function _getTraitToken() private view returns (ITrait) {
        return ITrait(_addressProvider.getTrait());
    }
}

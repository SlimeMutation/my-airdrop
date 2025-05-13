// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IAirdropManager {
    function depositETH() external payable returns (bool);
    function depositERC20(IERC20 tokenAddress, uint256 amount) external returns (bool);
    function claim(bytes32[] calldata proof, IERC20 tokenAddress, uint256 index, uint256 amount) external payable;
    function isClaimed(uint256 index) external view returns (bool);
    function withdrawETH(address payable withdrawAddress, uint256 amount) external payable returns (bool);
    function withdrawERC20(IERC20 tokenAddress, address withdrawAddress, uint256 amount) external returns (bool);
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./libraries/Merkle.sol";
import "./interfaces/IAirdropManager.sol";
import {Script, console} from "forge-std/Script.sol";


contract AirdropManager is Initializable, ReentrancyGuardUpgradeable, OwnableUpgradeable, IAirdropManager {
    address public constant ethAddress = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    address public withdrawManager;

    bytes32 public merkleRoot;

    mapping(address => uint256) public tokenBalance;

    mapping(uint256 => bool) public claimed;

    event DepositToken(
        address indexed tokenAddress,
        address indexed sender,
        uint256 amount
    );

    event WithdrawToken(
        address indexed tokenAddress,
        address sender,
        address withdrawAddress,
        uint256 amount
    );

    event Claimed(
        address indexed claimant,
        uint256 index,
        uint256 amount
    );

    constructor() {
        _disableInitializers();
    }

    modifier onlyWithdrawManager() {
        require(msg.sender == address(withdrawManager), "TreasureManager.onlyWithdrawer");
        _;
    }

    modifier notClaimed(uint256 index) {
        require(!claimed[index], "Already claimed");
        _;
    }

    /// @notice 初始化合约，设置初始所有者、提现管理员和Merkle根
    function initialize(address _initialOwner, address _withdrawManager, bytes32 _merkleRoot) public initializer {
        // Logging each parameter separately due to forge-std console limitations
        console.log("initialize called");
        console.log("owner: %s", _initialOwner);
        console.log("withdrawManager: %s", _withdrawManager);
        console.logBytes32(_merkleRoot);
        merkleRoot = _merkleRoot;
        withdrawManager = _withdrawManager;
        _transferOwnership(_initialOwner);
    }

    receive() external payable {}


    function depositETH() public payable nonReentrant returns (bool) {
        tokenBalance[ethAddress] += msg.value;
        emit DepositToken(
            ethAddress,
            msg.sender,
            msg.value
        );
        return true;
    }

    function depositERC20(IERC20 tokenAddress, uint256 amount) external returns (bool) {
        tokenAddress.transferFrom(msg.sender, address(this), amount);
        tokenBalance[address(tokenAddress)] += amount;
        emit DepositToken(
            address(tokenAddress),
            msg.sender,
            amount
        );
        return true;
    }

    function claim(bytes32[] calldata proof, IERC20 tokenAddress, uint256 index, uint256 amount) external payable notClaimed(index) {
        // bytes32 leaf = keccak256(abi.encodePacked(msg.sender, index, amount));
        bytes32 leaf = sha256(abi.encodePacked(msg.sender, index, amount));
        require(
            // Merkle.verifyInclusionKeccak(abi.encodePacked(proof), merkleRoot, leaf, index),
            Merkle.verifyInclusionSha256(abi.encodePacked(proof), merkleRoot, leaf, index),
            "Invalid proof"
        );
        tokenBalance[address(tokenAddress)] -= amount;
        claimed[index] = true;
        if (address(tokenAddress) == ethAddress) {
            (bool success, ) = msg.sender.call{value: amount}("");
            require(success, "Eth transfer failed");
        } else {
            tokenAddress.transfer(msg.sender, amount);
        }
        emit Claimed(msg.sender, index, amount);
    }

    function withdrawETH(address payable withdrawAddress, uint256 amount) external payable onlyWithdrawManager returns (bool) {
        require(address(this).balance >= amount, "Insufficient ETH balance in contract");
        tokenBalance[ethAddress] -= amount;
        (bool success, ) = withdrawAddress.call{value: amount}("");
        if (!success) {
            return false;
        }
        emit WithdrawToken(
            ethAddress,
            msg.sender,
            withdrawAddress,
            amount
        );
        return true;
    }

    function withdrawERC20(IERC20 tokenAddress, address withdrawAddress, uint256 amount) external onlyWithdrawManager returns (bool) {
        require(tokenBalance[address(tokenAddress)] >= amount, "Insufficient token balance in contract");
        tokenBalance[address(tokenAddress)] -= amount;
        tokenAddress.transfer(withdrawAddress, amount);
        emit WithdrawToken(
            address(tokenAddress),
            msg.sender,
            withdrawAddress,
            amount
        );
        return true;
    }

    function isClaimed(uint256 index) external view override returns (bool) {
        return claimed[index];
    }
}

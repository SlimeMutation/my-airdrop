// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import { AirdropManager } from "../src/AirdropManager.sol";

contract AirdropManagerTest is Test {
    AirdropManager public airdropManager;

    function setUp() public {
        airdropManager = new AirdropManager();
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Vm.sol";
import {Script, console } from "forge-std/Script.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {AirdropManager} from "../src/AirdropManager.sol";
import "../test/EmptyContract.sol";


contract AirdropManagerScript is Script {
    AirdropManager public airdropManager;
    AirdropManager public airdropManagerImplementation;
    EmptyContract public emptyContract;
    ProxyAdmin public airdropManagerProxyAdmin;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        emptyContract = new EmptyContract();
        TransparentUpgradeableProxy proxyAirdropManager = new TransparentUpgradeableProxy(address(emptyContract), deployerAddress, "");

        airdropManager = AirdropManager(payable(address(proxyAirdropManager)));

        airdropManagerImplementation = new AirdropManager();

        airdropManagerProxyAdmin = ProxyAdmin(getProxyAdminAddress(address(proxyAirdropManager)));

        bytes32 merkleRoot = 0x7875e1a9672dcba8805d430efa935196c3c7a458e250cb535508985eb2f2df83;

        airdropManagerProxyAdmin.upgradeAndCall(
            ITransparentUpgradeableProxy(address(airdropManager)),
            address(airdropManagerImplementation),
            abi.encodeWithSelector(
                AirdropManager.initialize.selector,
                msg.sender,
                msg.sender,
                merkleRoot
            )
        );

        console.log("airdropManager:", address(airdropManager));
        vm.stopBroadcast();
    }

    function getProxyAdminAddress(address proxy) internal view returns (address) {
        address CHEATCODE_ADDRESS = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
        Vm vm = Vm(CHEATCODE_ADDRESS);
        bytes32 adminSlot = vm.load(proxy, ERC1967Utils.ADMIN_SLOT);
        return address(uint160(uint256(adminSlot)));
    }
}

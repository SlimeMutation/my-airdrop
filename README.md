# theweb3-airdrop
The Web3 Airdrop

```
forge script script/AirdropManager.s.sol:AirdropManagerScript --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast -vvvv
```


# 查询 merkleRoot
```
cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "merkleRoot()(bytes32)"
0x7875e1a9672dcba8805d430efa935196c3c7a458e250cb535508985eb2f2df83
```


# 查询 claimed 状态
```
cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "isClaimed(uint256)(bool)" 0
```

# 充值eth
```
cast send 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "depositETH()" --value 8000000000000000000000 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 
```



# 查询余额
```
cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "tokenBalance(address)(uint256)" 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
```

# 领取空投
```
cast send 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "claim(bytes32[],address,uint256,uint256)" ["0x13694aaec2981a726e877aaf65041d085fbe1c3b07e7501fe78f3bede71d29ef","0x73a6380a71ebc92e90884f08a14cbb226716f1bd96f6e2486a233b16db1a3b73"] 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE 1 2000 --private-key 0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a


cast send 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "claim(bytes32[],address,uint256,uint256)" ["0x7168161bb365342020715a898d0234834017dc9f562d2112cbd661aba0217af9","0x73a6380a71ebc92e90884f08a14cbb226716f1bd96f6e2486a233b16db1a3b73"] 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE 0 1000 --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
```


# 部署信息
```
initialize called
owner: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
withdrawManager: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
0x7875e1a9672dcba8805d430efa935196c3c7a458e250cb535508985eb2f2df83
airdropManager: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
```

# 本地叶子节点证明生成
```
Merkle Root: 7875e1a9672dcba8805d430efa935196c3c7a458e250cb535508985eb2f2df83
Address: 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
index: 1
Amount: 2000
Proof: [13694aaec2981a726e877aaf65041d085fbe1c3b07e7501fe78f3bede71d29ef 73a6380a71ebc92e90884f08a14cbb226716f1bd96f6e2486a233b16db1a3b73]
hash=== 7875e1a9672dcba8805d430efa935196c3c7a458e250cb535508985eb2f2df83
root=== 7875e1a9672dcba8805d430efa935196c3c7a458e250cb535508985eb2f2df83
Merkle Proof verified successfully!
```


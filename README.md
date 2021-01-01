# Token Rescue
`TokenRescue.sol` is a contract to be extended by a base contract.

```js
contract Example is TokenRescue {

}
```

`TokenRescue.sol` allows the base contract to resuce tokens that are sent to the contract by mistake. This seems to be a common theme among staking contracts where beginners inadvertantly send tokens to the contract as a way to stake.

Here are some examples below:

https://etherscan.io/tx/0x7acaf65ea00dd2ad17630bdb2df496306bc38d198e55c13ec223027e80929a60
https://etherscan.io/tx/0xbfd5c4ef41ec755a3ce2a03e92b52c25f26266c3497d76994925a013a8ab0816
https://etherscan.io/tx/0x925f22ee52469a079d5f93f5ec5ff48df5dd47aa5fd5e9203d4dfb18290a9057
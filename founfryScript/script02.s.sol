// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//The two basic imports 
import "forge-std/Script.sol";
import "forge-std/console.sol";

//Also since we can't wrtie the Interface it is better to just import the program 
import {Counter} from "../src/Counter.sol";

contract Test is Script {
    Counter public counter = Counter(0x0165878A594ca255338adfa4d48449f69242Eb8F);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        counter.setNumber(55);
        uint num = counter.number();
        console.log(num);
        vm.stopBroadcast();

        uint number = counter.number();
        console.log(number);
    }
}
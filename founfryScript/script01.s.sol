// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol"; //Importing the script from build in library 
import {Counter} from "../src/Counter.sol"; //Importing the actual contract
import "forge-std/console.sol";

contract CounterScript is Script { //Declare that this is not a contract but its a Script 
    Counter public counter;   // The Counter we imported we will be accessing as counter .....basically counter -> Instance of Counter

    //function setUp() public {}  //Have no idea about this 

    function run() public {   // A function run in which we execute the scripting logic 

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));  //start the vm

        counter = new Counter();   //Have a confusion on this one what it does ...seems like an instance to me 
                                    //But wasn't it declared up ?? 

        counter.setNumber(42);

        vm.stopBroadcast(); //stop the vm 
        
        uint256 num = counter.number();
        console.log(num);
    }
}
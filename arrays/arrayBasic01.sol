// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

//Here are some basic array question to practice


contract Work{
    uint[] public val;

    //a function add(uint _val) that adds a value to the array
    function add(uint _val) public {
        val.push(_val);
    }

    //a function that takes an index and returns the element at that index.
    function getlenght() public view  returns (uint) {
        return val.length;
    }

    //a function that takes an index and returns the element at that index
    function getElement(uint _index) public view returns (uint) {
        return val[_index];
    }

    //a function that takes an index and a new value, then updates the element at that index
    function updateIndex(uint _index, uint _val) public returns (uint) {
        val[_index] = _val;
        return val[_index];
    }

    //a function that removes the last element from the array. Handle the case when the array is empty
    function removeLastElemet() public {
        require(val.length != 0, "Sorry array is empty");
        val.pop();
    }

    // a function that loops through the array and returns the sum of all its elements
    function add() public view  returns(uint) {
        require(val.length != 0);
        uint count;
        uint sum;
        //uint total;

        while (count != val.length) {
            uint i = val[count];
            sum += i;
            count++;
        }


        //using for loop can make life simpler

        // for(uint i=0; i < val.length; i++) {
        //     total += val[i];
        // }

        return sum;
    }

    // a function that takes a value and returns true if the array contains it, otherwise false
    function find(uint _num) public view returns (bool) {
        for(uint i = 0; i < val.length; i++) {
            if(_num == val[i]) {
                return true;
            } 
        }
        //smart move is using this return outside the loop
        return false;
    }

    //a function that removes an element at a given index while preserving the order of the remaining elements
    //didn't understood this one
    function remove(uint _index) public {
        require(_index < val.length, "Invalid index");

        for (uint i = _index; i < val.length - 1; i++) {
            val[i] = val[i + 1];
        }

        val.pop();
    }

}
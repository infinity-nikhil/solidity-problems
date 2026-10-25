// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

//Using a struct make an array if that kind of the struct and make a function to push the elements in that struct 

struct Student {
    string name;
    uint roll;
    address wallet;
    uint class;
    bool isPresent;
}

contract Class{
    //Initalize a struct using that above struct 
    Student[] public students; //meaning mai ek Student struct type ka ek array banana chahta hu and i will that array as students
                                // or will access that struct via students and the type is of Student type and is public

    //why not calldata or storage why memomry here??
    function registerStudents(string memory  _name, uint _roll, address _wallet, uint _class, bool _isPresent) public {
        //Now push those val in the struct 
        students.push(
            Student({            //While pushing we have to tell that the type will be of struct directly can't push 
                name: _name,
                roll: _roll,
                wallet: _wallet,
                class: _class,
                isPresent: _isPresent
            })
        );
    }
}
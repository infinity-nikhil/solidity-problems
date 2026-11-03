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

    //Method 1: Direct push
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

    //Despite of mentioning each feild seperatly ....just mention the struct type
    //it works bro i justed it out in remix ide and + 1 advantage is that we can return the saved the element after push
    function regirstOtherway(Student memory _student) public returns(Student memory) {
        //Store the student in an object and then push that object later into the array 
        Student memory studentProfile = Student({
            name: _student.name,
            roll: _student.roll,
            wallet: _student.wallet,
            class: _student.class,
            isPresent: _student.isPresent
        });

        students.push(studentProfile);

        return studentProfile;
    }
}
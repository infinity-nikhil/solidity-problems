// SPDX-License-Identifier: GPL-3.0
//Think about it
pragma solidity >=0.7.0 <0.9.0;

struct Person {
    string name;
    uint age;
    string country;
    //Now we want study details -> but the thing is details is itself a complex structure ..
    /*
    studies -> {
            string schoolName,
            uint 10thMarks,
            string clgName,
            uint cgpa
        }
    All this under this studies section we can't just declare it seperatly 
    */

    //see below made the struct now have to map/nest it
    Studies[] studies;  // we are saying Studies type ka ek struct hoga and usko access karenge studies se 
}

//So we make a seperate sturct for studies...later will map/nest it inside the Person

struct Studies {
    string schlName;
    uint tenMarks;
    string clgName;
    uint cgpa;
}

contract People {
    //Now declare the array to use it 
    Person[] public persons;
    //ahhh..the interesting thing would be to see how we pass data ....single struct hota to direct pass.....
    function register(string memory _name, uint _age, string memory _country) public returns (Person memory) {
        Person memory person = Person({
            name: _name,
            age: _age,
            country: _country,
            studies: new Studies[](0) //Later we will add somthing else
        });

        persons.push(person);
        return (person);
    }
}

//New knew something new here ...like in starting we don't want to pass any param leave it empty then ....
// studie: new Studies[](0); -> this is the syntax 

/** Earlier was tryin to do something like this.....
        Person memory person = Person({
            name: _name,
            age: _age,
            country: _country,
            studies: {
                schlName: _schl,
                tenMarks: _ten,
                clgName: clg,
                cgpa: _cgpa
            }
        });
 */
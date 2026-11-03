// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

//Previously we left study feild empty in this one will see ho to puch elements in it 

struct Person {
    string name;
    uint age;
    string country;
    Studies[] studies;
}

struct Studies{
    string schlName;
    uint tenMarks;
    string clgName;
    uint cgpa;
}

contract Profile {
    Person[] public persons;
    Studies[] public studies;

    //Previously assuming user didn't wanted to give his details then 
    function Indentity(string memory _name, uint _age, string memory _country) public returns(Person memory){
        Person memory person = Person({
            name: _name,
            age: _age,
            country: _country,
            studies: new Studies[](0)
        });

        persons.push(person);
        return person;
    }

    //Now making a function to take those details 
    function setStudies(uint _index, string memory _schl, uint _ten, string memory  _clg, uint _cgpa) public returns(Person memory) {
        //make the studies object/Instance as usual
        Studies memory study = Studies({
            schlName: _schl,
            tenMarks: _ten,
            clgName: _clg,
            cgpa: _cgpa
        });

        //now we can do studies.push(study) but wo to fir wahi usual way ho jayega.....then what to do ?
        //By reading the medium below solution we got the idea ...like pahle create the instance ..then 
        //puch into the existing array 

        Person storage reqPerson = persons[_index];
        reqPerson.push(study); //again it will not work...cause in MDN docs we are declaring the user and pushing
        //nested details simontaniously ..... -> We want that pahle create the person taab tak nested array remains 
        // = empty later with another function will push the details
    }

    //Anyways might well as try to push the code the way Medium says 
    function setPerson(string memory _name, uint _age, string memory _country,string memory _schl, uint _ten, string memory  _clg, uint _cgpa) public returns(Person memory) {
        //So according to the medium first create all the intances and object then push in peace

        //Creating the studies
        Studies memory study = Studies({
            schlName: _schl,
            tenMarks: _ten,
            clgName: _clg,
            cgpa: _cgpa
        });

        //Now the person 
        Person memory person = Person({
            name: _name,
            age: _age,
            country: _country,
            studies: study     //here we added that study array
        });

        persons.push(person);

        //Will it work ???? -> WHy ? why not ?
    }
}

/**  In Medium blog found something like this 
function setUser() public {
    uint userId = userCount++;
    string[] storage my_techstack = _techstack;
    my_techstack.push("Python");
    my_techstack.push("JavaScript");
    my_techstack.push("Solidity");
    CatDetails[] storage cats = _cats;
    CatDetails memory firstcat = CatDetails("Snuffles", 3, 'white');
    cats.push(firstcat);
        CatDetails memory secondcat = CatDetails("Garfield", 5, 'orange');
    cats.push(secondcat);
People memory yours_truly = People("Peter M. Ogwara", 155, "m", my_techstack, cats);
    user_id_to_details[userId] = yours_truly;
}
 */
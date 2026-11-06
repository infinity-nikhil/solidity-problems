// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

//Ok so last attempt failed as well .... just do as it the medium person says 

/**
function setUser() public {
    uint userId = userCount++;
    string[] storage my_techstack = _techstack;                         //function ke bahar declare karna hota hai na ??
    my_techstack.push("Python");
    my_techstack.push("JavaScript");                                                                 //These are insctances dumbFUCK
    my_techstack.push("Solidity");
    CatDetails[] storage cats = _cats;                                 //function ke bahar declare karna hota hai na??
    CatDetails memory firstcat = CatDetails("Snuffles", 3, 'white');
    cats.push(firstcat);
        CatDetails memory secondcat = CatDetails("Garfield", 5, 'orange');
    cats.push(secondcat);
People memory yours_truly = People("Peter M. Ogwara", 155, "m", my_techstack, cats);
    user_id_to_details[userId] = yours_truly;
}
 */

//As we can see techstack is a dynamic array while _cats is a fixed size array 

struct CatsDetails {
    string name;
    uint age;
    string color;
}

struct People {
    string name;
    uint height;
    string[] tech_stacks;
    CatsDetails[] cats;
}

contract Medium {
    //Making of arrays
    CatsDetails[] public _cats;
    string[] public _techstacks; //as told a dynamic array

    function setUser() public {
        CatsDetails memory firstCat = CatsDetails("Falana", 5, "orange");
        //I don't know i am getting confused like ....is array universal or private here ??
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

//Task one init the array struct of Freelancer and push them into the array

struct FreelancerProfile {
    uint256 id;
    string name;
    address wallet;
    uint256 experienceYears;
    bool isAvialabe;
    uint256 hourlyRateWei;
}

struct EmployerProfile {
    uint id;
    string name;
    bool isHiring;
    address wallet; 
}

contract DeWork{
    FreelancerProfile[] public freelancerProfiles;
    EmployerProfile[] public employerProfiles;

    mapping(uint => address) public freelancerIdToAddress;
    mapping (uint => address) public employerIdToAddress;

    event FreelancerProfileRegistered(uint256 freelancerId, address caller);
    event EmployerRegistered(uint256 employerId, address caller);

    function RegisterProfile(string calldata _name, address _wallet, uint _exp, bool _IsAvialabe, uint _rate) external {
        freelancerProfiles.push(
            FreelancerProfile({
                id: freelancerProfiles.length + 1,
                name: _name,
                wallet: _wallet,
                isAvialabe: _IsAvialabe,
                hourlyRateWei: _rate,
                experienceYears: _exp
            })
        );
        freelancerIdToAddress[freelancerProfiles.length - 1] = msg.sender; //explain why -1 here 
        emit FreelancerProfileRegistered(freelancerProfiles.length - 1, msg.sender);
    }

    //This is how we return an array
    function getProfile() public view returns(FreelancerProfile[] memory) { //why memory here
        return freelancerProfiles;
    }

    function registerEmploye(string calldata _name, bool _isHiring) external {
        //here we will see a new way of pushing the data in the array first we will create the object and 
        // then we will push it in the array 
        EmployerProfile memory employerProfile = EmployerProfile({
            id: employerProfiles.length,
            name: _name,
            isHiring: _isHiring,
            wallet: msg.sender
        });

        employerProfiles.push(employerProfile);
        //now the mapping and emiting the event as we saw earlier .... 
        employerIdToAddress[employerProfiles.length - 1] = msg.sender;
        emit EmployerRegistered(employerProfiles.length - 1, msg.sender);
    }

    function getEmploy() public view returns(uint) {
        return employerProfiles.length;
    }
}
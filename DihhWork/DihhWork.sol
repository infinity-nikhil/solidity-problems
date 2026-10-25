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

contract DeWork{
    FreelancerProfile[] public freelancerProfiles;


    function RegisterProfile(string memory _name, address _wallet, uint _exp, bool _IsAvialabe, uint _rate) public {
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
    }
}
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
    JobListing[] jobListing;
}

struct CreateJobListingInput {
    string title;
    string description;
    uint256 deadlineTimestamp;
    uint256 fixedPriceInWei;
}

struct JobListing{
    uint id;
    string title;
    string description;
    uint  deadlineTimestamp;
    bool isOpen;
    uint fixedPriceInWei;
    uint hiredFreelancerId;
    bool hasHiredFreelancer;
    bool isPaid;
}

contract DeWork{
    FreelancerProfile[] public freelancerProfiles;
    EmployerProfile[] public employerProfiles;

    mapping(uint => address) public freelancerIdToAddress;
    mapping (uint => address) public employerIdToAddress;
    mapping(uint256 => uint256) public employerBalance;

    event FreelancerProfileRegistered(uint256 freelancerId, address caller);
    event EmployerRegistered(uint256 employerId, address caller);

    error Dework_IncorrectJobCreationFee(uint expectedFee, uint actualFee);

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
            wallet: msg.sender,
            jobListing: new JobListing[](0)
        });

        employerProfiles.push(employerProfile);
        //now the mapping and emiting the event as we saw earlier .... 
        employerIdToAddress[employerProfiles.length - 1] = msg.sender;
        emit EmployerRegistered(employerProfiles.length - 1, msg.sender);
    }

    function getEmploy() public view returns (uint) {
        return employerProfiles.length;
    }

    function getNumberOfCreatedJobList(uint256 employerId) public view returns (uint256) {
        return employerProfiles[employerId].jobListing.length;
    }

    //Internal function used in here 
    function _getEmployerProfile(uint employerId) internal view returns (EmployerProfile storage) {
        return employerProfiles[employerId];
    }

    //In this one rather then passing each and every param of struct we use a new format 
    function CreateJobListing(uint employerId, CreateJobListingInput calldata jobListingInput) external payable  {
        uint fixedPriceForJob = jobListingInput.fixedPriceInWei;

        if(msg.value != fixedPriceForJob) {
            revert Dework_IncorrectJobCreationFee(fixedPriceForJob, msg.value);
        }

        EmployerProfile storage employerProfile = _getEmployerProfile(employerId);
        uint256 jobId = getNumberOfCreatedJobList(employerId);

        JobListing memory newJob = JobListing({
            id: jobId,
            title: jobListingInput.title,
            description: jobListingInput.description,
            deadlineTimestamp: block.timestamp + jobListingInput.deadlineTimestamp,
            isOpen: true,
            fixedPriceInWei: jobListingInput.fixedPriceInWei,
            hiredFreelancerId: 0,
            hasHiredFreelancer: false,
            isPaid: false
        });

        employerBalance[employerId] += jobListingInput.fixedPriceInWei;
        employerProfile.jobListing.push(newJob);
    }
}
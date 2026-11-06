// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.34;

struct FreelancerProfile {
    uint256 id;
    string name;
    address wallet;
    uint256 experienceYears;
    bool isAvailableHire;
    uint256 hourlyRateWei;
}

struct EmployerProfile {
    uint256 id;
    string name;
    address wallet;
    bool isHiring;
    JobListing[] jobListing;
}

struct CreateJobListingInput {
    string title;
    string description;
    uint256 deadlineTimestamp;
    uint256 fixedPriceInWei;
}

struct JobListing {
    uint256 id;
    string title;
    string description;
    uint256 deadlineTimestamp;
    bool isOpen;
    uint256 fixedPriceInWei;
    uint256 hiredFreelancerId;
    bool hasHiredFreelancer;
    bool isPaid;
}

contract DoubleDihh{
    uint256 public constant LATE_PENALITY_BPS_PER_DAY = 500; //500/10000 = 5%
    uint256 public constant BPS_DENOMINATOR = 10000; //100%

    //create an array for the struct 
    FreelancerProfile[] public freelancerProfiles;
    EmployerProfile[] public employerProfiles;

    //mappigns
    mapping(uint256 => uint256) public employerBalance;

    //modifiers 

    //In this one can simply apply the check for msg.sender
    modifier validEmployer(uint employerId) {
        if(msg.sender != employerProfiles[employerId].wallet) {
            revert();
        }
        _;
    }

    //for the hire function 
    //here the logic used is important
    modifier validJobId(uint256 employerId, uint256 jobId) {
        if(jobId >= employerProfiles[employerId].jobListing.length) {
            revert();
        }
        _;
    }

    //Now for the free lancer same logic
    modifier validFreelancer(uint256 freelancerId) {
        if(freelancerId >= freelancerProfiles.length) { // || freelancerIdToAddress[freelancerId] == address(0) 
            revert();                                       // in source code we have this too but i am not able to understand where we will use this 
        }
        _;
    }

    //events 
    event DoubleDihh_UserRegistered(uint256 _id, address caller);
    event DoubleDihh_EmployerRegistered(uint256 _id, address caller);
    event DoubleDihh_NewJob(uint256 _employerId, uint256 _jobId, address caller);

    //if we directly give data type of FreelancerProfile then we have to pass the id to and we don't want the user 
    //to pass it's own id we will assign them id not they can choose -> to we can either make a diff struct for each 
    // feild that has to be passed or just pass the manually !!
    function registerUser(string memory _name, uint _epxYrs, uint _rate) public {
        //now getting the if i.e. the index number 
        uint256 _id = freelancerProfiles.length;

        //Now register the user in the array 
        FreelancerProfile memory freelancerProfile = FreelancerProfile({
            id: _id,
            name: _name,
            wallet: msg.sender,
            experienceYears: _epxYrs,
            isAvailableHire: true,
            hourlyRateWei: _rate
        });

        freelancerProfiles.push(freelancerProfile);
        emit DoubleDihh_UserRegistered(_id, msg.sender);

        /* getuserId function and mapping to id to address not done yet ...we will see when we require it */
    }

    function registerEmployer(string memory _name) public {
        //again the id which is basically the index number
        uint256 _id = employerProfiles.length;

        EmployerProfile memory employerProfile = EmployerProfile({
            id: _id,
            name: _name,
            wallet: msg.sender,
            isHiring: true,
            jobListing: new JobListing[](0) //initally nothing
        });

        employerProfiles.push(employerProfile);
        emit DoubleDihh_EmployerRegistered(_id, msg.sender);
    }

    //Now to create the JobListing by employer
    //Only a valid employer can make the joblisting a modifier for that 
    function createJobs( uint256 employerId, CreateJobListingInput memory jobInput) public validEmployer(employerId) payable {
        //Our job is to take the employer id find that index of employerProfile 
        //get the length of the jobListing which will be the jobId of current listing 
        //And then push the jobListing to the employerProfile in the array

        EmployerProfile storage employerProfile = employerProfiles[employerId];
        //learned the hard way initially it was memeory .... but we are doing a push operation using this so storage

        uint256 jobId = employerProfile.jobListing.length;

        uint256 fixedPriceForJob = jobInput.fixedPriceInWei;

        if(msg.value != fixedPriceForJob) {
            revert();
        }

        JobListing memory newJob = JobListing({
            id: jobId,
            title: jobInput.title,
            description: jobInput.description,
            deadlineTimestamp: jobInput.deadlineTimestamp,
            fixedPriceInWei: jobInput.fixedPriceInWei,
            isOpen: true,
            hasHiredFreelancer: false,
            hiredFreelancerId: 0, //This is a bug ....since index is the mapping of freelancerId so at id 0 there is a freelancer
            isPaid: false
        });

        employerProfile.jobListing.push(newJob);
        emit DoubleDihh_NewJob(employerId, jobId, msg.sender);
        //Now have to create a mapping since the function is payable we will update the balace 
        employerBalance[employerId] += jobInput.fixedPriceInWei;
    }

    // Now the hire function ...
    //Here we have to check for valid jobId and valid freelancer
    function hireFunction(uint256 _employerId, uint256 _jobId, uint256 _freelancerId ) public 
    validEmployer(_employerId)
    validJobId(_employerId, _jobId)
    validFreelancer( _freelancerId) {
        //TODO: Get the job with the help of employerId and job id then update it 

        JobListing storage reqJob = employerProfiles[_employerId].jobListing[_jobId];
        require(reqJob.isOpen = true, "The task has already been assigned to someone else");

        reqJob.isOpen = false;
        reqJob.hiredFreelancerId = _freelancerId;
        reqJob.hasHiredFreelancer = true;
    }

    //Now the calculate Payment function
    //On the basis of delay we give the payment
    function _calculatePayment(uint256 amountToSend, uint256 jobDeadlineTimestamp) internal view returns(uint256)  {
        if (block.timestamp <= jobDeadlineTimestamp) {
            return amountToSend;
        }
        uint256 delayInCompletion = block.timestamp - jobDeadlineTimestamp;

        // Ceil division: rounds up to the next full day instead of truncating
        uint256 delayInDays = (delayInCompletion + 1 days - 1) / 1 days;

        uint256 deductionBps = delayInDays * LATE_PENALITY_BPS_PER_DAY; //500

        if (deductionBps > BPS_DENOMINATOR) {
            deductionBps = BPS_DENOMINATOR;
        }

        uint256 deductionAmount = (amountToSend * deductionBps) / BPS_DENOMINATOR; //(2000 * 500)/10000 = 100

        return amountToSend - deductionAmount; //2000 - 100 = 19000
    }

    // function to send the payment a lower level call 
    function _sendPayment(uint256 _amount, address _to) internal {
        (bool success, ) = _to.call{value: _amount}(""); //note it down something new this is how do a lower level call
        if(success == false) {                             //will be usefull in testing 
            revert();
        }
    }

    //ok so i guess one of the last payments which is release the payment 
    function releasePayments(uint256 _employerId, uint256 _jobId) external payable 
    validEmployer(_employerId)
    validJobId(_employerId, _jobId)
    {
        //get the job
        JobListing storage assignedJob = employerProfiles[_employerId].jobListing[_jobId];
        require(assignedJob.isPaid = false, "Already paid");

        uint256 promisedMoney = assignedJob.fixedPriceInWei;
        uint256 freelancerId = assignedJob.hiredFreelancerId;
        uint256 jobDeadline = assignedJob.deadlineTimestamp;

        address freelancerAddress = freelancerProfiles[freelancerId].wallet;

        //calculate the payment
        uint256 amountToSend = _calculatePayment(promisedMoney, jobDeadline);

        //send 
        _sendPayment(amountToSend, freelancerAddress);

        assignedJob.isPaid = true;
        employerBalance[_employerId] -= amountToSend;
    }

    //Now the function so that the employer can withdraw his funds 
    function withdraw(uint256 _employerId, uint256 _jobId) external 
    validEmployer(_employerId) 
    validJobId(_employerId, _jobId)
    {
        JobListing memory reqJob = employerProfiles[_employerId].jobListing[_jobId];
        require(reqJob.isOpen = true, "Job has already been assigned");

        uint256 amount = reqJob.fixedPriceInWei;
        address empAddress = employerProfiles[_employerId].wallet;
        employerBalance[_employerId] -= amount;

        (bool success,) = empAddress.call{value: amount}("");
        if(!success) {
            revert();
        }
    }
}

//Well that settles it then roughly completed
pragma solidity ^0.4.17;

contract Campaign {
    // Defining the Request structure--a description & cost for the proposal, an address for the party
    // the money is going to, a bool to mark the transaction complete, a uint to track the appr. count, 
    // and a mapping of the approving donors.
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    
    // Declaring our variables.
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    uint public fundersCount;
    
    // Eliminates the need for a for loop b/c it's gas-intense. 
    mapping(address => bool) public funders; 
    
    // Addon to manager-only functions.
     modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    // Constructor function: Manager creates the Campaign w/ a minimum contribution value.
    function Campaign(uint minimum) public {
        manager = msg.sender;
        minimumContribution = minimum;
    }
    
    // This is the contribute function, it's payable, requires a miminum cont.
    function contribute() public payable {
        require(msg.value > minimumContribution);
        
        funders[msg.sender] = true;
        
        fundersCount++;
    }
    
    // Allows the manager to submit a new funding request. 
    function createRequest(string description, uint value, address recipient) 
    public restricted {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });
        
        requests.push(newRequest);
    }
    
    // allows a funder to approve a request.
    function approvalRequest(uint index) public {
        Request storage request = requests[index];
        
        // requires 1) the individual to be a funder, & 2) the individual not yet have voted on this proposal.
        require(funders[msg.sender]);
        require(!request.approvals[msg.sender]);
        
        // adds their addr to the approvals mapping in this request and marks them as having voted yes.
        request.approvals[msg.sender] = true;
        
        // increments the approval count on this agenda item.
        request.approvalCount++;
    }
}


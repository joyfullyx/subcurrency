pragma solidity >= 0.7.0 < 0.9.0;

// the contract allows only its creator to create new coins (different issuance schemes are possible).
// anyone can send coins to each other without a need for registering with a username and password, all you need is an Ethereum keypair.

contract Coin {
    // keyword "public" makes variables accessible from other contracts
    address public minter;
    mapping (address => uint) public balances;

    // Events allow clients to react to specific contract changes you declare
    // Event is an inheritable member of a contract. An event is emitted, it stores the arguments passed in transaction logs
    // These logs are store on blockain and are accessible using address of the contract til the contract is present on the blockchain.
    event Sent(address from, address to, uint amount);

    // constructor only runs when we deploy contract
    constructor() {
        minter = msg.sender;
    }

    // make new coins and send them to an address
    // only the owner can sed these coins
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    // send any amount of coins to an existing address

    error insufficientBalance(uint requested, uint available);

    function send(address receiver, uint amount) public {
        // require amount to be greater than x = true and then run this:
        if(amount > balances[msg.sender])
        // revert stops transaction happening
        revert insufficientBalance({
            requested: amount,
            available: balances[msg.sender]
        });
        
        balances[msg.sender] -= amount;
        balances[receiver] += amount;

        // emit send event
        emit Sent(msg.sender, receiver, amount);
    }

}
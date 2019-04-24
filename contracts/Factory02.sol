pragma solidity ^0.4.24;

contract TokenInterface{
    uint256 public totalSupply;
    uint256 public price;
    uint256 public decimals;
    function () public payable;
    function balanceOf(address _owner) view public returns(uint256);
    function transfer(address _to, uint256 _value) public returns(bool);
}
contract Contract {
    address public owner; 
    mapping (address => uint256) balances; 

    function Contract () public{
        owner = msg.sender;
    }
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(balances[_from] >= _value);
        balances[_from] -= _value;
        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }
    function () public payable {
        msg.sender.transfer(address(this).balance);
    }
}
contract Factory {
    address[] arrContract;
    uint256 public totalSupply; 
    
    mapping (address => uint256) balances; 
    address MyETHWallet;

    function Factory() public {  
        MyETHWallet = msg.sender;
    }
    function createContract() public{
        Contract newContract = new Contract();
        arrContract.push(newContract);
    } 
    function getAddress() view public returns(address[]){
        return arrContract;
    }
    function getMyAddress() view public returns(address){
        return MyETHWallet;
    }

    function balanceOf(address _owner) view public returns(uint256){
        return balances[_owner];
    }
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Withdraw(address to, uint amount); //rut tien

    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(balances[_from] >= _value);
        balances[_from] -= _value;
        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }
    
    modifier onlyMyETHWallet(){
        require(msg.sender == MyETHWallet);
        _;
    }
    function checkAddress(address _address) view public returns(bool){
        for(uint i=0;i<arrContract.length;i++){
            if(_address == arrContract[i]) return true;
        }
        return false;
    }
    function withdrawEtherOnlyOwner() external  onlyMyETHWallet{
        msg.sender.transfer(address(this).balance);
        emit Withdraw(msg.sender,address(this).balance);
    }

    function withdrawFromAddress(address _address) external {
        if(checkAddress(_address)){
            msg.sender.transfer(_address.balance);
            emit Withdraw(msg.sender,_address.balance);
        }
    }

    function () public payable {
        uint256 token = msg.value;
        totalSupply += token;
    }
}
 
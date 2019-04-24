pragma solidity ^0.4.0;

contract TokenInterface{
    uint256 public totalSupply;
    uint256 public price;
    uint256 public decimals;
    function () public payable;
    function balanceOf(address _owner) view public returns(uint256);
    function transfer(address _to, uint256 _value) public returns(bool);
}

contract NewToken{
    
    uint256 public totalSupply; 
    uint256 public price = 100;
    uint256 public decimals = 0; 

    address MyETHWallet;
    constructor() public {  
        MyETHWallet = msg.sender;
    }

    
    mapping (address => uint256) balances; 
    mapping (address => mapping (address => uint256)) public allowance; //phu cap

    function setPrice(uint256 _price) public returns (uint256){
        price = _price;
        return price;
    }

    function setDecimals(uint256 _decimals) public returns (uint256){
        decimals = _decimals;
        return decimals;
    }
    
    function balanceOf(address _owner) view public returns(uint256){
        return balances[_owner];
    }
    
    //tạo ra một sự kiện công khai trên blockchain sẽ thông báo cho khách hàng
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Withdraw(address to, uint amount); //rut tien

    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(balances[_from] >= _value);
        require(balances[_to] + _value >= balances[_to]);
        
        uint previousBalances = balances[_from] + balances[_to];
        
        balances[_from] -= _value;
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        
        assert(balances[_from] + balances[_to] == previousBalances);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);  
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
   
    function () public payable {
        uint256 token = (msg.value*price)/10**uint256(decimals); //1 eth = 10^18 wei
        totalSupply += token;
        balances[msg.sender] += token;
    }

    // function setOwner(address _addr) public returns (address){
    //     MyETHWallet = _addr;
    //     return MyETHWallet;
    // }
    
    function getOwner() view public returns (address){
        return MyETHWallet;
    }
        
    modifier onlyMyETHWallet(){
        require(msg.sender == MyETHWallet);
        _;
    }
    //myAddress = this;
    function withdrawEtherOnlyOwner() external  onlyMyETHWallet{
        msg.sender.transfer(address(this).balance);
        emit Withdraw(msg.sender,address(this).balance);
    }

    function sendFund(address _receiver, uint amount) external{
        require(_receiver != 0x0);
        if(0 < amount && amount <= address(this).balance) {
            _receiver.transfer(amount);
        }
    }
}
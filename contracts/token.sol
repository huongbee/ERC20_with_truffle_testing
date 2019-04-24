pragma solidity ^0.4.0;

contract TokenInterface{
    uint256 public totalSupply;
    function () public payable;
    function balanceOf(address _owner) view public returns(uint256);
    function transfer(address _to, uint256 _value) public returns(bool);
}

contract Token{
    
    modifier onlyValidAddress(address _to){
        require(_to != address(0x00));
        _;
    }
    modifier onlyValidValue(address _from,uint256 _value){
        require(_value < balances[_from]);
        _;
    }
    
    uint256 public totalSupply = 9000000000000000000; 
    
    mapping (address => uint256) balances; 
    mapping (address => mapping (address => uint256)) public allowance; //phu cap

    //tạo ra một sự kiện công khai trên blockchain sẽ thông báo cho khách hàng
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    function balanceOf(address _owner) view public returns(uint256){
        return balances[_owner];
    }
    
    // function transfer(address _to, uint256 _value) onlyValidAddress(_to) onlyValidValue(msg.sender, _value)
    // public returns(bool){
    //     balances[msg.sender] -= _value;
    //     balances[_to] += _value;
    //     return true;
    // }
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(balances[_from] >= _value);
        require(balances[_to] + _value >= balances[_to]);
        // Save this for an assertion in the future
        uint previousBalances = balances[_from] + balances[_to];
        
        balances[_from] -= _value;
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balances[_from] + balances[_to] == previousBalances);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
   
    //mỗi khi có ai đó gửi Ethereum tới sẽ nhận lại Token theo tỉ lệ 1:100
    //msg.value chứa giá trị eth 
    function () public payable {
        uint256 token = (msg.value*100)/10**18; //1 eth = 10^18 wei
        totalSupply += token;
        balances[msg.sender] = token;
    }
    
   
}
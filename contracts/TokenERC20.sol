pragma solidity ^0.4.18;

contract TokenInterface{
    uint256 public totalSupply;
    function () public payable;
    function balanceOf(address _owner) view public returns(uint256);
    function transfer(address _to, uint256 _value) public returns(bool);
}

contract ERC20Token{
    
    modifier onlyValidAddress(address _to){
        require(_to != address(0x00));
        _;
    }
    modifier onlyValidValue(address _from,uint256 _value){
        require(_value < balances[_from]);
        _;
    }
    
    uint256 public totalSupply; 
    uint256 public rate = 100;
    uint256 public decimals = 18;
    
    mapping (address => uint256) balances; 
    mapping (address => mapping (address => uint256)) public allowance; //phu cap

    //tạo ra một sự kiện công khai trên blockchain sẽ thông báo cho khách hàng
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    function balanceOf(address _owner) view public returns(uint256){
        return balances[_owner];
    }
    function setRate(uint256 _rate)  public returns(uint256){
        rate = _rate;
        return rate;
    }
    function setDecimals(uint256 _decimals)  public returns(uint256){
        if(_decimals<=18){
            decimals = _decimals;
            return decimals;
        }
        else{
            return decimals;
        }
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
        
        assert(balances[_from] + balances[_to] == previousBalances);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if(_value <= allowance[_from][msg.sender]){ 
            allowance[_from][msg.sender] -= _value;
            _transfer(_from, _to, _value);
            return true;
        }
        else return false;
    }

    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
   
    //mỗi khi có ai đó gửi Ethereum tới sẽ nhận lại Token theo tỉ lệ 1:100
    //msg.value chứa giá trị eth 
    function () public payable {
        uint256 token = (msg.value*rate)/10**uint256(decimals); //1 eth = 10^18 wei
        totalSupply += token;
        balances[msg.sender] = token;
    }
    
   //0.000000000000000001


   /**
   2 0xbD89d8892a8a1e0aa1f57F6b21518AC03b7DE881 0.024079439
   1 0x2CCB02f5ed8CB9A33b8bEF0d3d942F579a3616d0 0.01973959
   
    */
}

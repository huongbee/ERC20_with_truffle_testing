pragma solidity ^0.4.0;
import "./token02.sol";

contract Greeter {
    
    TokenInterface Token;
    
    address MyETHWallet = 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF; 
    uint256 public rate = 100;
    
    modifier onlyValidAddress(address _to){
        require(_to != address(0x00));
        _;
    }
    
    modifier onlyMyETHWallet(){
        require(msg.sender == MyETHWallet);
        _;
    }
    //set address reveive eth and send token 
    function setETHWallet(address _MyETHWallet) public returns(address){
        MyETHWallet = _MyETHWallet;
        return MyETHWallet;
    }
    
    function setRate(uint256 _rate) onlyMyETHWallet public returns(uint256){
        rate = _rate;
        return rate;
    }
    
    constructor(address _tokenAddress) onlyValidAddress(_tokenAddress)  public {
        Token = TokenInterface(_tokenAddress);
    }
    
    /// @notice Buy tokens from contract by sending ether
    function buyToken() onlyValidAddress(msg.sender) public payable {
        uint256 _value = (msg.value*rate)/10**18;
        assert(Token.transfer(msg.sender, _value));
        MyETHWallet.transfer(msg.value);
    }
    
    // function withdraw(address token, uint256 amount) returns (bool success) {
       
    // }
}
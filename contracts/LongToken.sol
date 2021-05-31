pragma solidity ^0.4.24;


contract SafeMath {
  function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
    assert(b > 0);
    uint256 c = a / b;
    assert(a == b * c + a % b);
    return c;
  }

  function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
    uint256 c = a + b;
    assert(c>=a && c>=b);
    return c;
  }

}

contract LONGTOKEN is SafeMath{
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 private Destruction = 30;
    
    mapping (address => uint256) public balanceOf;
	
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Burn(address indexed from, uint256 value);

    event Buy(address indexed from, uint256 value);
    

    constructor()public{
        totalSupply = 21000000 * 10**5 * 10**9;
        balanceOf[address(msg.sender)]=totalSupply;
        name = "Long Token";
        symbol = "LONG";
        decimals = 9;
    }


    function _transfer(address _from,address _to, uint256 _value)private returns(uint256){
        require(_value > 0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        uint256  _amount;
        _amount=SafeMath.safeSub(_value,SafeMath.safeDiv(SafeMath.safeMul(_value,Destruction),100));
        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _amount);
        totalSupply=SafeMath.safeSub(totalSupply,SafeMath.safeSub(_value,_amount));
        return _amount;
    }

    function transfer(address _to, uint256 _value) public returns(bool success){
        uint256 _amount=_transfer(msg.sender,_to,_value);
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _value)public returns (bool success) {
        require(_value > 0);
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);
        uint256 _amount=_transfer(_from,_to,_value);
        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
        emit Transfer(_from, _to, _amount);
        return true;
    }

    function burn(uint256 _value) public returns (bool success) {
        require(SafeMath.safeDiv(SafeMath.safeMul(address(this).balance,_value),totalSupply)>=1);
        require(balanceOf[msg.sender] >= _value);
        require(_value > 0);
        require(totalSupply>=_value);
        address(msg.sender).transfer(SafeMath.safeDiv(SafeMath.safeMul(address(this).balance,_value),totalSupply));
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
        totalSupply = SafeMath.safeSub(totalSupply,_value);
        emit Burn(msg.sender, _value);
        return true;
    }
    function queryBurn(uint256 _value)public view returns(uint256){
        return SafeMath.safeDiv(SafeMath.safeMul(address(this).balance,_value),totalSupply);
    }
    
    function OKTbalance()view public returns(uint256){
        return address(this).balance;
    }
    
	function() payable public {
    }
   
}

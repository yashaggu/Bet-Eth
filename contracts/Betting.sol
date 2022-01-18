pragma solidity >0.4.99;
contract Betting{
    address payable public owner;
    uint256 public minbet;
    uint256 public totalBetOne;
    uint256 public totalBetTwo;
    uint256 public numberofbets;
    uint256 public maxbets = 1000;

    address payable [] public players;

    struct player{
        uint256 amountbet;
        uint256 teamSelected;
    }
    mapping(address => player) public playerinfo;

    constructor() public {
        owner = payable(msg.sender);
        minbet = 100000000000000;
    }


function kill() public {
    if(msg.sender == owner) selfdestruct(owner);
}

function checkPlayerExists(address player) public view returns(bool){
    for(uint256 i=0 ; i<players.length ; i++)
    {
        if(players[i] == player) return true;
    }
    return false;
}

function bet(uint8 _teamselected) public payable{
    require(!checkPlayerExists(msg.sender));
    require(msg.value >= minbet);

    playerinfo[msg.sender].amountbet = msg.value;
    playerinfo[msg.sender].teamSelected = _teamselected;
    players.push(payable(msg.sender));

    if(_teamselected == 1)
    {
        totalBetOne += msg.value;
    }
    else
    {
        totalBetTwo += msg.value;
    }
}

function distributeprizes(uint16 teamwinner) public{
    address payable[1000] memory winners;

    uint256 count = 0;
    uint256 loserbet = 0;
    uint256 winnerbet = 0;

    address add;
    uint256 bet;
    address payable playeraddress;

    for(uint256 i=0 ; i<players.length ; i++)
    {
        playeraddress = players[i];

        if(playerinfo[playeraddress].teamSelected == teamwinner)
        {
            winners[count] = playeraddress;
            count++;
        }
    }

    if(teamwinner == 1)
    {
        loserbet = totalBetTwo;
        winnerbet = totalBetOne;
    }
    else
    {
        loserbet = totalBetOne;
        winnerbet = totalBetTwo;
    }

    for(uint256 i=0 ; i<count ; i++)
    {
        if(winners[i] != address(0))
        {
            add = winners[i];
            bet = playerinfo[add].amountbet;
            winners[i].transfer(bet * (1 + (loserbet/winnerbet)));
        }
    }

    delete playerinfo[playeraddress];
    loserbet = 0;
    winnerbet = 0;
    totalBetOne = 0;
    totalBetTwo = 0;
}

function amountone() public view returns(uint256){
    return totalBetOne;
}

function amounttwo() public view returns(uint256){
    return totalBetTwo;
}

}

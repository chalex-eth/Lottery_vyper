# @version 0.2.16

interface AggregatorV3Interface:
    def latestRoundData() -> (int256, int256,uint256,uint256,int256) : view 

interface VRFConsumerInterface:
    def getRandomNumber(): payable
    def returnRandomNumber() -> uint256: view
    

owner: address
priceFeed: public(AggregatorV3Interface)
Lottery_State: uint256 # 0: Closed, 1: Open, 2: Calculating winner
usdEntryFee: public(uint256)
players: public(HashMap[uint256,address])
Count: uint256
VRFConsumer: public(VRFConsumerInterface)
randomNumber: public(uint256)
winner: public(address)

@external
def __init__(_priceFeed: address, _VRFConsumer_address: address):
    self.owner = msg.sender
    self.Lottery_State = 0 # Lottery closed at init, need to be started
    self.priceFeed = AggregatorV3Interface(_priceFeed)
    self.usdEntryFee = 50*10**18
    self.VRFConsumer = VRFConsumerInterface(_VRFConsumer_address)
    

@view
@internal
def _getPrice() -> int256:
    a: int256 = 0
    price: int256 = 0
    b: uint256 = 0
    c: uint256 = 0
    d: int256 = 0
    (a,price,b,c,d) = self.priceFeed.latestRoundData() 
    return (price * 10000000000)

@view
@internal
def _getEntranceFee() -> uint256:
    price: int256 = self._getPrice()
    ethPrice: uint256 = convert(price,uint256)
    costToEnter: uint256 = (self.usdEntryFee * 1000000000000000000) / ethPrice
    return costToEnter

@internal
def _generateRandom():
    self.VRFConsumer.getRandomNumber()

@external
def startLottery():
    assert self.owner == msg.sender, "Only owner can start the lottery"
    assert self.Lottery_State == 0, "Can't start a new lottery yet!"
    self.Lottery_State = 1


@payable
@external
def enter():
    assert self.Lottery_State == 1, 'Lottery not started'
    assert msg.value >= self._getEntranceFee(), "Not enough fund to participate"
    self.players[self.Count] = msg.sender
    self.Count += 1 

@external
def endLottery():
    assert msg.sender == self.owner
    assert self.Lottery_State == 1, "Lottery is not open"
    self.Lottery_State = 2
    self._generateRandom()
    
    
@external
def calculatingWinner():
    assert msg.sender == self.owner
    self.randomNumber = self.VRFConsumer.returnRandomNumber()
    assert self.randomNumber != 0
    indexOfWinner: uint256 = self.randomNumber % self.Count
    self.winner = self.players[indexOfWinner]
    send(self.players[indexOfWinner],self.balance)
    self.Lottery_State = 0
    # We should reset the players HashMap

@view
@external
def getWinner() -> address:
    return self.winner

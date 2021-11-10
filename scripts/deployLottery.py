from brownie import Lottery, VRFConsumer
from scripts.helpful_scripts import get_account
from sys import exit
from web3 import Web3
import time

eth_usd_price_feed = "0x9326BFA02ADD2366b30bacB125260Af641031331"


def check_deployedVRF():
    if len(VRFConsumer) == 0:
        print(
            "First you need to deploy the VRFconsumer contract and fund the VRF with LINK token"
        )
        VRF = 0
    else:
        VRF = VRFConsumer[-1]
    return VRF


def deployLottery(VRF):
    print("Deploying lottery")
    lottery = Lottery.deploy(eth_usd_price_feed, VRF.address, {"from": get_account()})


def startingLottery():
    lottery = Lottery[-1]
    print("Starting lottery")
    lottery.startLottery({"from": get_account()})


def enterInLottery(EthAmount):
    lottery = Lottery[-1]
    print(f"Entering in lottery with {EthAmount} Eth")
    lottery.enter({"from": get_account(), "value": Web3.toWei(EthAmount, "Ether")})


def endLottery():
    lottery = Lottery[-1]
    print("Ending lottery")
    lottery.endLottery({"from": get_account()})


def calculatingWinner():
    lottery = Lottery[-1]
    winner = lottery.calculatingWinner({"from": get_account()})
    return winner


def getWinner():
    lottery = Lottery[-1]
    return lottery.getWinner()


def main():
    VRF = check_deployedVRF()
    if VRF == 0:
        exit(0)
    deployLottery(VRF)
    startingLottery()
    enterInLottery(0.1)
    endLottery()
    time.sleep(60)
    calculatingWinner()
    print(getWinner())

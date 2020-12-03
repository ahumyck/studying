# -*- coding: utf-8 -*-
"""
Created on Fri Dec  4 01:02:46 2020

@author: ahumy
"""

from web3 import Web3
from deployment_api import generate_bin, generate_abi

def get_content(filename):
    with open(filename, "r") as f:
        return f.read()

url = "http://127.0.0.1:8545"

web3 = Web3(Web3.HTTPProvider(url))


contract_sol = "contract.sol"
sol_name = "ValueKeeper"  

    
#bin_filename = generate_bin(contract_sol, sol_name)
#abi_filename = generate_abi(contract_sol, sol_name)

bin_filename = "contract_sol_ValueKeeper.bin"
abi_filename = "contract_sol_ValueKeeper.abi"

account = web3.eth.get_accounts()[0]

web3.eth.defaultAccount = account

print(web3.eth.getBalance(account))
abi = get_content(abi_filename)
byte_code = get_content(bin_filename)
Greeter = web3.eth.contract(abi=abi, bytecode=byte_code)
tx_hash = Greeter.constructor().transact()
tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash)
contract = web3.eth.contract(address = tx_receipt["contractAddress"], abi = abi)


tx_hash = contract.functions.tryUpdateValue(100, 101).transact()
web3.eth.waitForTransactionReceipt(tx_hash)
r = contract.functions.getValue(100).call()
print(web3.eth.getBalance(account))
print(r, type(r))

ccc = web3.eth.contract(address = tx_receipt["contractAddress"], abi = abi)
print(web3.eth.getBalance(account))
print(ccc.functions.getValue(100).call())
print(web3.eth.getBalance(account))

try:
    tx_hash = ccc.functions.tryUpdateValue(100, 102).transact()
    web3.eth.waitForTransactionReceipt(tx_hash)
    r = contract.functions.getValue(100).call()
    print(web3.eth.getBalance(account))
    print(r, type(r))
except Exception as se:
    print(web3.eth.getBalance(account))
    print(se)
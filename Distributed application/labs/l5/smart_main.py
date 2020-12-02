# -*- coding: utf-8 -*-
"""
Created on Wed Dec  2 21:34:52 2020

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

web3.eth.defaultAccount = web3.eth.get_accounts()[0]

abi = get_content(abi_filename)
byte_code = get_content(bin_filename)
Greeter = web3.eth.contract(abi=abi, bytecode=byte_code)
tx_hash = Greeter.constructor().transact()
tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash)
contract = web3.eth.contract(address = tx_receipt["contractAddress"], abi = abi)
print(contract.functions.getValue().call())

tx_hash = contract.functions.setValue(101).transact()
web3.eth.waitForTransactionReceipt(tx_hash)
r = contract.functions.getValue().call()
print(r, type(r))
# -*- coding: utf-8 -*-
"""
Created on Wed Dec  2 23:05:25 2020

@author: ahumy
"""

import os

def generate_bin(filename, contract_name):
    return generate(filename, contract_name, "bin")

def generate_abi(filename, contract_name):
    return generate(filename, contract_name, "abi")

def generate(filename, contract_name, ext):
    os.system("solcjs --" + ext + " " + filename)
    abi_filename = os.path.splitext(filename)[0] + "_sol_" + contract_name + "." + ext
    return abi_filename
    

if __name__ == "__main__":
    contract_sol = "contract.sol"
    sol_name = "ValueKeeper" 
    
    bin_filename = generate_bin(contract_sol, sol_name)
    abi_filename = generate_abi(contract_sol, sol_name)
    
    print("contract data generated")
    
    
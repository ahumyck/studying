# -*- coding: utf-8 -*-
"""
Created on Thu Dec  3 02:34:14 2020

"""

from web3 import Web3
from faker import Faker
import os

bin_filename = "contract_sol_ValueKeeper.bin"
abi_filename = "contract_sol_ValueKeeper.abi"
        
url = "http://127.0.0.1:8545"

def get_content(filename):
    with open(filename, "r") as f:
        return f.read()



class User():
    def __init__(self, account, name, address):
        self.name = name # имя пользователя
        self.address = address # адрес
        self.id = os.urandom(20) # уникальный айди 20 байт
        self.account = account # аккаунт пользователя
        self.contractAddresses = [] # контракты пользователя
        
    def get_balance(self):
        return web3.eth.getBalance(self.account) # функция для получения кол-во "денег" на счету пользователя
    
    def create_contract(self, tx_manager, value):
        abi, byte_code = self.__get_transaction_data__()
        self.contractAddresses.append(tx_manager.create_contract(self, abi, byte_code, value))
    
    def update_contract_value(self, tx_manager, contract_address, value):  #функция для обновления параметра пользователя
        balance_before_transaction = self.get_balance()
        abi, byte_code = self.__get_transaction_data__()
        transaction_result = tx_manager.update_contract_value_with_transaction(self, contract_address, abi, value)
        if transaction_result:
            print("Transaction successfully completed")
            print("Balance before transaction:", balance_before_transaction)
            print("Balance after transaction:", self.get_balance())
            
    def get_contract_value(self, tx_manager, contract_address):
        abi, byte_code = self.__get_transaction_data__()
        contract_value = tx_manager.get_contract_value(self, contract_address, abi)
        if contract_value is not None:
            return contract_value
        else: raise Exception("contract value is None")
        
         
    def __get_transaction_data__(self): #функция получения данных для произвдения транзакции
        abi = get_content(abi_filename)
        byte_code = get_content(bin_filename)
        return abi, byte_code
    
    def __str__(self): # функия, чтобы можно было распечатать информацию о пользователе
        self_information = "name = {}\naddress = {}\naccount = {}\ncontracts = {}\nbalance = {}\n\n"
        return self_information.format(self.name, self.address, self.account, self.contractAddresses, self.get_balance())


class TransactionManager():
    def __init__(self):
        self.default_account = web3.eth.defaultAccount
        
    def create_contract(self, user, contract_abi, contract_byte_code, value):
        web3.eth.defaultAccount = user.account # с какого пользователя снять деньги за произведение транзакции
        contract = web3.eth.contract(abi=contract_abi, bytecode=contract_byte_code) # получаем модель контракта
        tx_hash = contract.constructor().transact() # получаем хеш транзакции
        tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash) # получаем данные о транзакции 
        self.add_user_contract_with_transaction(user, tx_receipt["contractAddress"], contract_abi, value)
        web3.eth.defaultAccount = self.default_account
        return tx_receipt["contractAddress"]; #возвращаем адрес контракта
    
    def add_user_contract_with_transaction(self, user, contract_address, contract_abi, value):
        try:
            web3.eth.defaultAccount = user.account # с какого пользователя снять деньги за произведение транзакции
            contract = web3.eth.contract(address = contract_address, abi = contract_abi) # получаем контракт пользователя из блокчейна
            tx_hash = contract.functions.addUser(user.id, user.name, user.address, value).transact() # получаем хеш транзакции
            # именно данная функция будет выбрасывать исключение в случае, если прошло
            # меньше 30 дней с момента предыдущей транзакции
            
            web3.eth.waitForTransactionReceipt(tx_hash) # дожидаемся конца транзакции
            web3.eth.defaultAccount = self.default_account
            return True # Transaction successfully completed
        except Exception as e: # поймали ошибку
            print(e) # распечатываем сообщение 
            web3.eth.defaultAccount = self.default_account
            return False # transaction successfully failed
    
    def update_contract_value_with_transaction(self, user, contract_address, contract_abi, value): # функиця обновления контракта
        try:
            web3.eth.defaultAccount = user.account # с какого пользователя снять деньги за произведение транзакции
            contract = web3.eth.contract(address = contract_address, abi = contract_abi) # получаем контракт пользователя из блокчейна
            tx_hash = contract.functions.tryUpdateValue(user.id, value).transact() # получаем хеш транзакции
            # именно данная функция будет выбрасывать исключение в случае, если прошло
            # меньше 30 дней с момента предыдущей транзакции
            
            web3.eth.waitForTransactionReceipt(tx_hash) # дожидаемся конца транзакции
            web3.eth.defaultAccount = self.default_account
            return True # Transaction successfully completed
        except Exception as e:
            print(e) # распечатываем сообщение 
            web3.eth.defaultAccount = self.default_account
            return False # transaction successfully failed
        
    def get_contract_value(self, user, contract_address, contract_abi):
        try:
            contract = web3.eth.contract(address = contract_address, abi = contract_abi) # получаем контракт пользователя из блокчейна
            return contract.functions.getValue(user.id).call() # получаем данные о искомом параметре
        except Exception as e:
            print(e)
            return None
      
        
class UserContainer():
    def __init__(self):
        self.users = dict()
            
    def get_user(self, account):
        return self.users[account]
    
    def add_user(self, account, name, address):
        self.users[account] = User(account, name, address)
        
    def __str__(self):
        user_info = ""
        for user_key in self.users:
            user = self.users[user_key]
            user_info += user.__str__()
        return user_info
    
    def get_accounts(self):
        return list(self.users.keys())


if __name__ == "__main__":
    web3 = Web3(Web3.HTTPProvider(url)) # создаем сервис, который подключается к блокчейну
    user_container = UserContainer() # создаем контейнер пользователей
    tx_manager = TransactionManager() # создаем менеджер транзакций
    fake = Faker() # фейкер для создания имен и адресов
    
    for account in web3.eth.get_accounts(): # создаем фейковых пользователей блокчейна
        user_container.add_user(account, fake.name(), fake.address())
    
    while True:
        print(user_container)
        print("1. Create contract for user")
        print("2. Update user contract value")
        print("3. Check user contract value")
        
        response = int(input())
        
        account = input("Provide user account: ")
        user = user_container.get_user(account)
        
        if response != 3:
            value = int(input("Provide value(integer): "))
        
        if response == 1:
            user.create_contract(tx_manager, value)
            input();
            continue;

        
        contract_address = input("Provide user's contract address: ")
        if response == 2:
            user.update_contract_value(tx_manager, contract_address, value)
            input()
            continue
            
        if response == 3:
            try:
                value = user.get_contract_value(tx_manager, contract_address)
                print("Contract[{}] = {}".format(contract_address, value))
                input()
            except Exception:
                print("No such key in contract")
                
                
            
            
            
            







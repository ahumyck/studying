# -*- coding: utf-8 -*-
"""
Created on Thu Dec  3 02:34:14 2020

"""

from web3 import Web3
import datetime
from faker import Faker

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
        self.account = account # аккаунт пользователя
        self.parametersValue = -1 # параметр пользователя
        self.parametersTime = -1 # когда в последний раз параметр обновлялся
        
    def get_balance(self):
        return web3.eth.getBalance(self.account) # функция для получения кол-во "денег" на счету пользователя
    
    def update_value_with_transaction(self, tx_manager, value): #функция для обновления параметра пользователя
        if self.parametersTime == -1: # если данный параметр ещё не обновлялся
            self.parametersTime = datetime.datetime.now() # то говорим, что параметр обновился сейчас
            return self.__make_transaction__(tx_manager, value) # производим транзакцию
        else: # если данный параметр обновлялся
            last_time_updated = self.parametersTime # смотрим, когда параметр обновлялся в последний раз
            current_transaction_time = datetime.datetime.now() # берем текущее значение даты
            time_passed = current_transaction_time - last_time_updated # кол-во времени прошедшее с последней транзакции
            days_passed = divmod(time_passed.total_seconds() , 24*60*60)[0] # кол-во дней, прошедшее с последней транзакции
            print(time_passed) # печатаем эту инфу
            if days_passed > 30: # если кол-во прошедших дней с последней транзакции больше 30 
                self.parametersTime = current_transaction_time # обновляем время транзакции
                return self.__make_transaction__(tx_manager, value) # производим транзакцию
            print("Falied on transaction because 30 days time passed less than 30 days") # сообщение об ошибке
            return False # если кол-во прошедшних дней меньше 30, то транзакцию не производим
        
    def __get_transaction_data__(self): #функция получения данных для произвдения транзакции
        abi = get_content(abi_filename)
        byte_code = get_content(bin_filename)
        return abi, byte_code
    
    def __make_transaction__(self, tx_manager, value):
        abi, byte_code = self.__get_transaction_data__() # получаем данные для произведения транзакции
        print("balance before transaction:", self.get_balance()) # распечатываем кол-во денег на счету пользователя
        newValue = tx_manager.update_contract_value_with_transaction(self.account, abi, byte_code, value) # производим транзакцию
        print("balance after transaction:", self.get_balance()) # распечатываем кол-во денег, чтобы увидеть, что деньги списались
        print("new value:" , newValue) # выводим на экран новое значение контракта
        self.parametersValue = newValue
        return True # говорим, что транзакция прошла успешно
    
    def get_value(self):
        return self.parametersValue
    
    def __str__(self): # функия, чтобы можно было распечатать информацию о пользователе
        self_information = "account = {}\nbalance = {}\nname = {}\naddress = {}\value = {}\nlast time updated = {}\n\n"
        return self_information.format(self.account, self.get_balance(), self.name, self.address, self.parametersValue, self.parametersTime)



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



class TransactionManager():
    def __init__(self):
        self.default_account = web3.eth.defaultAccount
        
    def __get_contract_transaction__(self, from_account, contract_abi, contract_byte_code): # функция получения контракта из транзакции
        web3.eth.defaultAccount = from_account # с какого пользователя снять деньги за произведение транзакции
        ValueKeeper = web3.eth.contract(abi=contract_abi, bytecode=contract_byte_code) # получаем модель контракта
        tx_hash = ValueKeeper.constructor().transact() # получаем хеш транзакции
        tx_receipt = web3.eth.waitForTransactionReceipt(tx_hash) # получаем данные о транзакции
        contract = web3.eth.contract(address = tx_receipt["contractAddress"], abi = contract_abi) # получаем контракт
        return contract #возвращаем контракт
    
    def update_contract_value_with_transaction(self, from_account, contract_abi, contract_byte_code, value): # функиця обновления контракта
        contract = self.__get_contract_transaction__(from_account, contract_abi, contract_byte_code) # получаем контракт
        tx_hash = contract.functions.setValue(value).transact() # производим обновление контракта
        web3.eth.waitForTransactionReceipt(tx_hash) # дожидаемся обновление контракта
        newValue = contract.functions.getValue().call() # получаем обновленное значение из контракта
        web3.eth.defaultAccount = self.default_account # убираем пользователя, чтобы с него не снимались деньги
        return newValue # возвращаем обновленное значение из контракта



if __name__ == "__main__":
    web3 = Web3(Web3.HTTPProvider(url)) # создаем сервис, который подключается к блокчейну
    user_container = UserContainer() # создаем контейнер пользователей
    tx_manager = TransactionManager() # создаем менеджер транзакций
    fake = Faker() # фейкер для создания имен и адресов
    
    for account in web3.eth.get_accounts(): # создаем фейковых пользователей блокчейна
        user_container.add_user(account, fake.name(), fake.address())
    
    print(user_container) # печатаем всех пользователей
        
    while True:
        account = input("Account: ") # вводим аккаунт
        
        if account == "stop": #если имя аккаунта является стоп словом, прекращаем работу
            break
        
        newValue = int(input("New value: ")) # вводим новое значение атрибута
        user = user_container.get_user(account) # получаем пользователя
        if newValue == -987: #магическое значение -987
            print(user) # печатаем пользователя
            continue
        user.update_value_with_transaction(tx_manager, newValue) #обновляем пользователя








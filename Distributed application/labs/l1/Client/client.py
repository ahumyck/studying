#!/usr/bin/python3
# -*- coding: utf-8 -*-
import socket
import json
import ssl
from skimage.util import random_noise
from skimage.io import imread, imsave

imageName = "img.png"
noiseImageName = "noise.png"
#paramsPath = "C:\\Users\\ahumy\\OneDrive\\Рабочий стол\\Studying\\Protected distributed application protection technology\\labs\\lab1\\params.json"
paramsPath = "D:\\labs\\studying\\Distributed application\\labs\\l1\\params.json"

chunkSize = 4096

def getServerAddress(serverInformationFilepath):
    """
        Функция для получения адреса 
        и порта сервера из файла
    """
    with open(serverInformationFilepath) as serverAddress:
        address = json.load(serverAddress)
        return address['HOST'], address['PORT']

def noiseImage(inputImageName, outputImageName, sigma=0.155):
    """
        Функция для создания шума в изображении
    """
    original = imread(inputImageName) #читаем обычный файл
    noisy = random_noise(original, var=sigma**2) #добавляем шум
    imsave(outputImageName, noisy) #записываем зашумленный файл


def sendImageName(sock, imageName):
    sock.sendall(str.encode(imageName)) #отправляем через сокет имя файла

def sendImageSize(sock, imageName):
    f = open(imageName, 'rb') #открываем файл
    size = len(f.read()) #узнаем его размер
    sock.sendall(str.encode(str(size))) #отправляем размер файла через сокет, предварительно переведя информацию в байты
    f.close() # закрываем файлы


def sendImage2(sock, imageName):
    f = open(imageName, 'rb') #открываем файл
    while True: #бесконечный цикл
        chunk = f.read(chunkSize) #читаем байты из файла
        if not chunk: break #если байты закончились, выходим из цикла
        sock.sendall(chunk) #отправляем через сокет изображение
    f.close() #закрываем файл



if __name__ == "__main__":
    host, port = getServerAddress(paramsPath) #получаем адрес сервера
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0) as sock: #создаем сокет
        print('Wrapping socket')
        ssock = ssl.wrap_socket(sock) #оборачиваем сокет в SSL
        print('Connecting')
        ssock.connect((host, port)) #подключаемся к серверу
        noiseImage(imageName, noiseImageName) #добавляем шум сообщению
        print('Sending image name')
        sendImageName(ssock, noiseImageName) #отправляем имя файла
        print('Sending image size')
        sendImageSize(ssock, noiseImageName) #отправляем размера файла
        print('Sending image')
        sendImage2(ssock, noiseImageName) #отправляем файл
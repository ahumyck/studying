import os
import cv2
from base_camera import BaseCamera

import socketserver
import json
import socket
import ssl
import cv2


paramsPath = "params.json"
chunkSize = 4096


def parseParameters(serverInformationFilepath):
    with open(serverInformationFilepath) as serverAddress:
        address = json.load(serverAddress)
        return address['HOST'], address['PORT']


def getImageSize(sock):
    rawData = sock.recv(chunkSize)
    return int(rawData.decode())

def getImage(sock, imageSize):
    number_of_chunks = imageSize // chunkSize
    r = imageSize - number_of_chunks * chunkSize

    res = b''

    for i in range(number_of_chunks):
        l = sock.recv(chunkSize)
        res += l
    
    if r != 0:
        l = sock.recv(r)
        res += l

    return res

class Camera(BaseCamera):
    @staticmethod
    def frames():
        print("getting frames")
        host, port = parseParameters(paramsPath) #получаем адрес сервера
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock: #создаем сокет
            print('Server started')
            sock.bind((host, port)) #привязываем сокет к адресу
            print('listening')
            sock.listen(1) # "слушаем" подключения
            connection, client_address = sock.accept() #принимаем подключение
            print('client connected: {}'.format(client_address))
            while True:
                imageSize = getImageSize(connection) #получаем размер зашумленного файла
                print("got image size: {}".format(imageSize))
                yield getImage(connection, imageSize) #получаем зашумленный файл

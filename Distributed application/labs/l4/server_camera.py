import os
import cv2
from base_camera import BaseCamera

import socketserver
import json
import socket
import ssl
import cv2


chunkSize = 4096

def getImageSize(sock):
    rawData = sock.recv(chunkSize)
    #int.from_bytes(rawData, "big")   
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
    def __init__(self, socket):
        super().__init__(socket)

    @staticmethod
    def frames():
        while True:
            imageSize = getImageSize(BaseCamera.connection) #получаем размер зашумленного файла
            #print("got image size: {}".format(imageSize))
            yield getImage(BaseCamera.connection, imageSize) #получаем зашумленный файл

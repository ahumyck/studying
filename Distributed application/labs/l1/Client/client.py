#!/usr/bin/python3
# -*- coding: utf-8 -*-
import socket
import json
import ssl
import pickle

from skimage.io import imread

imageName = "noise_weak.png"
paramsPath = "C:\\Users\\ahumy\\OneDrive\\Рабочий стол\\Studying\\Protected distributed application protection technology\\labs\\lab1\\params.json"

chunkSize = 4096

def getServerAddress(serverInformationFilepath):
    with open(serverInformationFilepath) as serverAddress:
        address = json.load(serverAddress)
        return address['HOST'], address['PORT']

def sendImageName(sock, imageName):
    sock.sendall(str.encode(imageName))

def sendImageSize(sock, imageName):
    f = open(imageName, 'rb')
    size = len(f.read())
    sock.sendall(str.encode(str(size)))
    f.close()


def sendImage2(sock, imageName):
    f = open(imageName, 'rb')
    while True:
        chunk = f.read(chunkSize)
        if not chunk: break
        sock.sendall(chunk)
    f.close()



if __name__ == "__main__":
    host, port = getServerAddress(paramsPath)
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0) as sock:
        print('Wrapping socket')
        ssock = ssl.wrap_socket(sock)
        print('Connecting')
        ssock.connect((host, port))
        print('Sending image name')
        sendImageName(ssock, imageName)
        print('Sending image size')
        sendImageSize(ssock, imageName)
        print('Sending image')
        sendImage2(ssock, imageName)
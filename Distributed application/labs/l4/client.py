#!/usr/bin/python3
# -*- coding: utf-8 -*-
import socket
import json
import ssl
from skimage.util import random_noise
from skimage.io import imread, imsave
import cv2
import random
import numpy as np

paramsPath = "params.json"
#video_source = "video.mp4"
video_source = 0

chunkSize = 4096

def getServerAddress(serverInformationFilepath):
    """
        Функция для получения адреса 
        и порта сервера из файла
    """
    with open(serverInformationFilepath) as serverAddress:
        address = json.load(serverAddress)
        return address['HOST'], address['PORT']


def noiseImage(image,prob):
    output = np.zeros(image.shape,np.uint8)
    thres = 1 - prob 
    for i in range(image.shape[0]):
        for j in range(image.shape[1]):
            rdn = random.random()
            if rdn < prob:
                output[i][j] = 0
            elif rdn > thres:
                output[i][j] = 255
            else:
                output[i][j] = image[i][j]
    return output


def sendImageSize(sock, size):
    sock.sendall(str.encode(str(size))) #отправляем размер файла через сокет, предварительно переведя информацию в байты


def sendImage(sock, frame):
    length = len(frame)
    number_of_chunks = length // chunkSize

    r = length - number_of_chunks * chunkSize

    for i in range(number_of_chunks):
        chunk = frame[i * chunkSize: (i+1) * chunkSize]
        sock.sendall(chunk)
    
    if r != 0:
        chunk = frame[number_of_chunks * chunkSize: number_of_chunks * chunkSize + r]
        sock.sendall(chunk)



if __name__ == "__main__":
    host, port = getServerAddress(paramsPath) #получаем адрес сервера
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0) as sock: #создаем сокет
        print('Connecting')
        sock.connect((host, port)) #подключаемся к серверу
        camera = cv2.VideoCapture(video_source)

        skip_count = 100
        current_skip = 0

        while True:
            success, image = camera.read()
            if not success:
                camera.release()
                camera = cv2.VideoCapture(video_source)
                continue

            
            image = cv2.resize(image, (600, 800))
            # image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
            # image = noiseImage(image, 0.1)
            image = cv2.flip(image, 1)
            image = cv2.imencode('.jpg', image)[1].tobytes()
            
            
            #print('Sending image size')
            sendImageSize(sock, len(image)) #отправляем размера файла
            #print('Sending image')
            sendImage(sock, image) #отправляем файл

#!/usr/bin/env python
from importlib import import_module
import os
import json
import socket
from flask import Flask, render_template, Response

# import camera driver
# if os.environ.get('CAMERA'):
#     Camera = import_module('camera_' + os.environ['CAMERA']).Camera
# else:
#     from camera import Camera

from server_camera import Camera

# Raspberry Pi camera module (requires picamera package)
# from camera_pi import Camera

app = Flask(__name__)
sock = 0
connection = 0
client_address = 0

paramsPath = "params.json"

def parseParameters(serverInformationFilepath):
    with open(serverInformationFilepath) as serverAddress:
        address = json.load(serverAddress)
        return address['HOST'], address['PORT']

@app.route('/')
def index():
    """Video streaming home page."""
    return render_template('index.html')


def gen(camera):
    """Video streaming generator function."""
    print("I am here")
    while True:
        print("Trying to get frame")
        frame = camera.get_frame()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')


@app.route('/video_feed')
def video_feed():
    """Video streaming route. Put this in the src attribute of an img tag."""
    return Response(gen(Camera(connection)), mimetype='multipart/x-mixed-replace; boundary=frame')


if __name__ == '__main__':
    print("getting frames")
    host, port = parseParameters(paramsPath) #получаем адрес сервера
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #создаем сокет
    print('Server started')
    sock.bind((host, port)) #привязываем сокет к адресу
    print('listening')
    sock.listen(1) # "слушаем" подключения
    connection, client_address = sock.accept() #принимаем подключение
    print('client connected: {}'.format(client_address))
    app.run(host='0.0.0.0', threaded=True)

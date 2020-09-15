import socketserver
import json
import socket
import ssl
import pickle

from skimage.restoration import denoise_tv_chambolle, denoise_tv_bregman, denoise_bilateral, denoise_wavelet
from skimage.io import imread
import matplotlib.pyplot as plt

path = "C:\\Users\\ahumy\\OneDrive\\Рабочий стол\\Studying\\Protected distributed application protection technology\\labs\\lab1\\params.json"

chunkSize = 4096


def parseParameters(serverInformationFilepath):
    with open(serverInformationFilepath) as serverAddress:
        address = json.load(serverAddress)
        return address['HOST'], address['PORT']

def getImageName(sock):
    imageNameAsBytes = sock.recv(chunkSize)
    return imageNameAsBytes.decode()

def getImageSize(sock):
    rawData = sock.recv(chunkSize)
    return int(rawData.decode())

def getAndSaveImage2(sock, imageName, imageSize):
    f = open(imageName, 'wb')
    currentImageSize = 0
    while currentImageSize < imageSize:
        l = sock.recv(chunkSize)
        f.write(l)
        currentImageSize += chunkSize
    f.close()
    return True


def denoise(noisy, weight):
    return denoise_tv_chambolle(noisy, weight=weight, multichannel=True)

def denoiseAndCompare(noisy, weight=0.1, figsize = (16, 8)):
    fig, ax = plt.subplots(nrows=1, ncols=4, figsize=figsize,
                       sharex=True, sharey=True)

    ax[0].imshow(noisy)
    ax[0].axis('off')
    ax[0].set_title('Noisy')

    print("Denoise Total Variance")
    ax[1].imshow(denoise_tv_chambolle(noisy, weight=0.1, multichannel=True))
    ax[1].axis('off')
    ax[1].set_title('Total Variance')

    print("Denoise bilateral")
    ax[2].imshow(denoise_bilateral(noisy, sigma_color=0.05, sigma_spatial=15, multichannel=True))
    ax[2].axis('off')
    ax[2].set_title('Bilateral')

    print('Denoise wavelet')
    ax[3].imshow(denoise_wavelet(noisy, multichannel=True, rescale_sigma=True))
    ax[3].axis('off')
    ax[3].set_title('Wavelet denoising')

    fig.tight_layout()

    plt.show()


if __name__ == "__main__":
    host, port = parseParameters(path)
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        ssock = ssl.wrap_socket(sock, 'localhost.key', 'localhost.crt', True) 
        print('Server started')
        ssock.bind((host, port))
        print('listening')
        ssock.listen(1)
        connection, client_address = ssock.accept()
        print('client connected: {}'.format(client_address))
        imageName = getImageName(connection)
        print("got image name: {}".format(imageName))
        imageSize = getImageSize(connection)
        print("got image size: {}".format(imageSize))
        result = getAndSaveImage2(connection, imageName, imageSize)
        if result: denoiseAndCompare(imread(imageName))

    
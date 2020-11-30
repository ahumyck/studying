# -*- coding: utf-8 -*-
"""
Created on Sun Nov 29 22:56:36 2020

@author: ahumy
"""

import numpy as np
from resources import watermark
from PIL import Image

import distorsion
from distorsion_manager import AreaDistorsionManager, BaseDistorsionManager

area_dir = "/resources/area/"
jpeg_dir = "/resources/jpeg/"
median_dir = "/resources/median/"
sharpering_dir = "/resources/sharpering/"

original_image = "resources/pepper.pgm"
embedded_image = "resources/embed.pgm"

def area_test():
    R = 5
    N = R * R
    dist = distorsion.AreaDistorsion()
    manager = AreaDistorsionManager(dist)
    original_image = np.arange(N).reshape(R, R)
    image = np.power(original_image, 2)
    
    for it in manager.apply(original_image, image):
        print(it)
        
def sharpering_test():
    R = 5
    N = R * R
    dist = distorsion.SharperingDistorsion()
    manager = BaseDistorsionManager(dist)
    original_image = np.arange(N).reshape(R, R)
    
    for it in manager.apply(original_image):
        print(it)
        
def median_test():
    R = 5
    N = R * R
    dist = distorsion.MedianFilterDistorsion()
    manager = BaseDistorsionManager(dist)
    original_image = np.arange(N).reshape(R, R)
    
    for it in manager.apply(original_image):
        print(it)
    
def jpeg_test():
    dist = distorsion.JpegDistorsion()
    manager = BaseDistorsionManager(dist)
    original_image = Image.open('image.jpg')
    
    for it in manager.apply(original_image):
        print(it)
        
        
watermark.embed(original_image, embedded_image, 'wang')


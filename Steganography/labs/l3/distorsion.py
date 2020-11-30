# -*- coding: utf-8 -*-
"""
Created on Sun Nov 29 22:20:06 2020

@author: ahumy
"""

import numpy as np        
from scipy.ndimage import convolve, median_filter
from io import BytesIO


class AreaDistorsion(): 
    def __init__(self):
        pass
    
    def apply(self, original_image, image, theta):
        N1, N2 = image.shape
        copy = np.copy(original_image)
        n1 = int(N1 * np.sqrt(theta))
        n2 = int(N2 * np.sqrt(theta))
        copy[0:n1, 0:n2] = image[0:n1, 0:n2]
        return copy
        
        return image
    
    def get_parameters(self):
        return 0.2, 0.9, 0.1
    
    
class SharperingDistorsion():
    def __init__(self):
        self.A = 5
    
    def apply(self, image, N):
        smooth = convolve(image, np.ones(N*N).reshape(N, N) / N)
        dist = image + self.A * (image - smooth)
        dist[np.where(dist < 0)] = 0
        return dist
    
    def get_parameters(self):
        return 3, 15, 2
    
    

class MedianFilterDistorsion():
    def __init__(self):
        pass
    
    def apply(self, image, N):
        return median_filter(image, size = N)
    
    def get_parameters(self):
        return 3, 15, 2
    


class JpegDistorsion():
    def __init__(self):
        pass
    
    def apply(self, image, QF):
        out = BytesIO()
        image.save(out, format = 'jpeg', quality = QF)
        return out
    
    def get_parameters(self):
        return 30, 90, 10
    
    
    
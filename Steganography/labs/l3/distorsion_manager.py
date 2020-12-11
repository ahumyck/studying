# -*- coding: utf-8 -*-
"""
Created on Sun Nov 29 22:47:35 2020

@author: ahumy
"""


class BaseDistorsionManager():
    def __init__(self, distorsion):
        self.distorsion = distorsion
        
    def apply(self, image):
        lower, upper, delta = self.distorsion.get_parameters()        
        value = lower
        
        while lower <= value and value <= upper:
            yield self.distorsion.apply(image, value)
            value += delta
            

class JpegDistorsionManager():
    def __init__(self, distorsion):
        self.distorsion = distorsion
    
    def parameters(self):
        lower, upper, delta = self.distorsion.get_parameters()  
        value = lower
        
        while lower <= value and value <= upper:
            yield value
            value += delta
    
    

class AreaDistorsionManager():
    def __init__(self, distorsion):
        self.distorsion = distorsion
        
    def apply(self, original_image, image):
        lower, upper, delta = self.distorsion.get_parameters()        
        value = lower
        
        while lower <= value and value <= upper:
            yield self.distorsion.apply(original_image, image, value)
            value += delta
    
            
        
    
    
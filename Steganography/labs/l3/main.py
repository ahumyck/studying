# -*- coding: utf-8 -*-
"""
Created on Sun Nov 29 22:56:36 2020

@author: ahumy
"""

from extractor import WatermarkDistorsionedImageExtractor
from watermark import Watermark

import pickle

def save_pickle(obj, name):
    with open(name + '.pkl', 'wb') as f:
        pickle.dump(obj, f, pickle.HIGHEST_PROTOCOL)


original_image = "peppers.pgm"
embedded_image = "embed3.pgm"

if __name__ == "__main__":
    manager = WatermarkDistorsionedImageExtractor(Watermark(Watermark.WANG))
    manager.watermark_image(original_image, embedded_image)
    manager.area_distorsion(original_image, embedded_image)
    manager.jpeg_distorsion(original_image, embedded_image)
    manager.sharpering_distorsion(original_image, embedded_image)
    manager.median_distorsion(original_image, embedded_image)
    result = manager.compare()
    
    for wm in result:
        print("{} = {}".format(wm, result[wm]))
        
    save_pickle(result, "result")
# -*- coding: utf-8 -*-
"""
Created on Fri Nov 27 19:22:38 2020

@author: ahumy
"""

import numpy as np

def replace_arr(arr, mapping):
    return np.array([mapping[element] for element in arr])

def replace(matrix, mapping):
    return np.array([replace_arr(arr, mapping) for arr in matrix])
# -*- coding: utf-8 -*-
"""
Created on Sat Nov  7 18:53:25 2020

@author: ahumy
"""

import pickle

def save_pickle(obj, name):
    with open(name + '.pkl', 'wb') as f:
        pickle.dump(obj, f, pickle.HIGHEST_PROTOCOL)

def load_pickle(name):
    with open(name + '.pkl', 'rb') as f:
        return pickle.load(f)
# -*- coding: utf-8 -*-
"""
Created on Sat Nov  7 18:25:49 2020

@author: ahumy
"""

import math
from collections import OrderedDict
from operator import itemgetter 

def tf(word, document) -> int:
    return document.count(word)

def df(word, documents) -> int:
    return sum([tf(word, document) for document in documents])

def idf(word, documents) -> float:
    return math.log10(len(documents)/(df(word, documents) + 1))


def tf_idf(word, document, documents) -> float:
    return tf(word, document) * idf(word, documents)

def tf_idf_map_builder(documents) -> dict:
    tf_idf_map = dict()
    for i, document in enumerate(documents):
        print("{} / {}".format(i, len(documents) - 1))
        for word in document:
            if word not in tf_idf_map:
                tf_idf_map[word] = tf_idf(word, document, documents)
    return OrderedDict(sorted(tf_idf_map.items(), key = itemgetter(1), reverse = False))
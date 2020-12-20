# -*- coding: utf-8 -*-
"""
Created on Sat Nov  7 03:23:24 2020

@author: ahumy
"""

import pandas as pd
import tfidf
import dict_file
import learning
import mapping
from sklearn.feature_extraction.text import TfidfVectorizer


spamFilename = "spam.csv"


def get_csv_data(filename):
    return pd.read_csv(filename, encoding = 'cp1251')

def split_data(data):
    return remap_types(data['v1']).values, data['v2'].values

def split_messages_by_words(messages):
    vectorizer = TfidfVectorizer()
    analyze = vectorizer.build_analyzer()
    splited_by_words = []
    for message in messages:
        splited_by_words.append(analyze(message))
    return splited_by_words

def join_to_pairs(messages):
    result = []
    for message in messages:
        subresult = []
        for i in range(len(message) - 1):
            subresult.append(message[i] + " " + message[i + 1])
        result.append(subresult)
    return result
            
    
def get_data_and_build_tf_idf_map_then_save_it_to_file(documents, output_filename):
    tf_idf_map = tfidf.tf_idf_map_builder(documents)
    dict_file.save_pickle(tf_idf_map, output_filename)
    return tf_idf_map

def load_tf_idf_map(filename):
    return dict_file.load_pickle(filename)

def remap_types(types):
    d = {'spam' : 1, 'ham' : 0}
    return types.map(d)

def precision(cnf):
    tp = cnf[0, 0]
    fp = cnf[0, 1]
    
    return tp / (tp + fp)

def recall(cnf):
    tp = cnf[0, 0]
    fn = cnf[1, 0]
    
    return tp / (tp + fn)
    


data = get_csv_data(spamFilename)
types, messages = split_data(data)
documents = split_messages_by_words(messages)
paired = join_to_pairs(documents)
#tf_idf = get_data_and_build_tf_idf_map_then_save_it_to_file(paired, "tf_idf")
tf_idf = load_tf_idf_map("tf_idf")
info = mapping.replace(paired, tf_idf)
cnf_matrix = learning.main(info, types)
print('precision =', precision(cnf_matrix))
print('recall =', recall(cnf_matrix))




        
# -*- coding: utf-8 -*-
"""
Created on Sat Nov  7 03:23:24 2020

@author: ahumy
"""

import pandas as pd
import tfidf
import dict_file
import learning
#import numpy as np
#import pprint
from message import Message
from sklearn.feature_extraction.text import TfidfVectorizer


spamFilename = "spam.csv"


def get_csv_data(filename):
    return pd.read_csv(filename, encoding = 'cp1251')

def build_spam_array(data):
    types = data['v1'].values
    messages = data['v2'].values
    
    message_array = []
    for i in range(len(types)):
        message_array.append(Message(types[i], messages[i]))
    return message_array

def split_data(data):
    return remap_types(data['v1']).values.reshape(-1, 1), data['v2'].values

def split_messages_by_words(messages):
    vectorizer = TfidfVectorizer()
    analyze = vectorizer.build_analyzer()
    splited_by_words = []
    for message in messages:
        splited_by_words.append(analyze(message))
    return splited_by_words
    
def get_data_and_build_tf_idf_map_then_save_it_to_file(data_filename, output_filename):
    data = get_csv_data(spamFilename)
    types, messages = split_data(data)
    documents = split_messages_by_words(messages)
    tf_idf_map = tfidf.tf_idf_map_builder(documents)
    dict_file.save_pickle(tf_idf_map, "tf_idf")

def load_tf_idf_map(filename):
    return dict_file.load_pickle(filename)

def remap_types(types):
    d = {'spam' : 1, 'ham' : 0}
    return types.map(d)
    


data = get_csv_data(spamFilename)
types, messages = split_data(data)
learning.main(types, messages)



        
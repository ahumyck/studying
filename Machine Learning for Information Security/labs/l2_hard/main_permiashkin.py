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
    return remap_types(data['v1']).values, data['v2']

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
    

# <----- Убираем стоп слова, делаем нормализацию, нормализацию ----->
import nltk
import string
import pymorphy2
from sklearn.preprocessing import LabelEncoder

from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize

#nltk.download('punkt')
#nltk.download('stopwords')

def spacy_tokenizer(sentence):     
    punctuations = string.punctuation 
    morph = pymorphy2.MorphAnalyzer()
    tokens = word_tokenize(sentence)
    tokens = [token.lower() for token in tokens]
    tokens = [morph.parse(token)[0].normal_form for token in tokens] 
    tokens = [word for word in tokens if (word not in punctuations) and (word not in stopwords.words('english'))] 
    return ' '.join(tokens)

data_source = "spam.csv"

df = pd.read_csv(data_source, encoding = 'cp1252')
messages = df['v2'].values

# <----------------------------------------------------------------->

data = get_csv_data(spamFilename)
types, messages = split_data(data)
messages = messages.apply(spacy_tokenizer)
documents = split_messages_by_words(messages)
paired = join_to_pairs(documents)
#tf_idf = get_data_and_build_tf_idf_map_then_save_it_to_file(paired, "tf_idf")
tf_idf = load_tf_idf_map("tf_idf")
info = mapping.replace(paired, tf_idf)
cnf_matrix = learning.main(info, types)
print('precision =', precision(cnf_matrix))
print('recall =', recall(cnf_matrix))




        
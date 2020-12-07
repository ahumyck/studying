# -*- coding: utf-8 -*-
"""
Created on Sat Nov  7 19:20:54 2020

@author: ahumy
"""

import matplotlib.pyplot as plt
import numpy as np
import itertools
from sklearn.metrics import confusion_matrix
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.metrics import classification_report


def test_train_split(types, messages):
    return train_test_split(types, messages, test_size=0.33, random_state=42) # X_train, X_test, y_train, y_test


def learn(x_train, y_train):
    lr = LogisticRegression(random_state=42)
    lr.fit(x_train, y_train)
    return lr


def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Blues):
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix, without normalization')

    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, cm[i, j],
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    

def main(x, y):
    mlb = MultiLabelBinarizer()
    x = mlb.fit_transform(x)
    X_train, X_test, y_train, y_test = test_train_split(x, y)
    lr = learn(X_train, y_train)
    font = {'size' : 15}
    
    plt.rc('font', **font)
    
    
    cnf_matrix = confusion_matrix(y_test, lr.predict(X_test))
    plt.figure(figsize=(10, 8))
    plot_confusion_matrix(cnf_matrix, classes=['Spam', 'Ham'],
                          title='Confusion matrix')
    plt.show()
    return cnf_matrix
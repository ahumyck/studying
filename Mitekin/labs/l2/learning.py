# -*- coding: utf-8 -*-
"""
Created on Sat Nov  7 19:20:54 2020

@author: ahumy
"""

import matplotlib.pyplot as plt
#from matplotlib.pylab import rc, plot
#import seaborn as sns
import numpy as np
import itertools
#from itertools import product
from sklearn.metrics import confusion_matrix
#from sklearn.preprocessing import LabelEncoder, OneHotEncoder
#from sklearn.model_selection import cross_val_score
from sklearn.linear_model import LogisticRegression
#from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
#from sklearn.metrics import precision_recall_curve, classification_report
from sklearn.model_selection import train_test_split


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

    print(cm)

    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, cm[i, j],
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    

def main(types, messages):
    X_train, X_test, y_train, y_test = test_train_split(types, messages)
    print('splitted')
    lr = learn(X_train, y_train)
    print('learned')
    font = {'size' : 15}
    
    plt.rc('font', **font)
    
    
    cnf_matrix = confusion_matrix(y_test, lr.predict(X_test))
    print('confusion matrix')
    print(cnf_matrix.shape)
    #plt.figure(figsize=(10, 8))
    #plot_confusion_matrix(cnf_matrix, classes=['Spam', 'Ham'],
    #                      title='Confusion matrix')
    #plt.savefig("conf_matrix.png")
    #print('here before show')
    #plt.show()
    #print('here after show')
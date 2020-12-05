import pandas as pd

from sklearn.feature_extraction.text import TfidfVectorizer

import matplotlib.pyplot as plt
import numpy as np
import itertools

from sklearn.metrics import confusion_matrix
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.metrics import classification_report


data_source = "spam.csv"

def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Blues):
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]

    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, cm[i, j],
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    
def read_data(filename):
    return pd.read_csv(filename, encoding = 'cp1251')

def split_data(data):
    return remap_types(data['v1']).values, data['v2'].values

def tfidf(messages):
    vectorizer = TfidfVectorizer()
    return vectorizer.fit_transform(messages)

def remap_types(types):
    d = {'spam' : 1, 'ham' : -1}
    return types.map(d)


message_type, messages = split_data(read_data(data_source))
tf_idf = tfidf(messages)

mlb = MultiLabelBinarizer()
messages = mlb.fit_transform(messages)
x_train, x_test, y_train, y_test = train_test_split(messages, message_type, test_size=0.33, random_state=42)
    
lr = LogisticRegression(random_state=42)
lr.fit(x_train, y_train)   
    
classes = ['Spam', 'Ham']

cnf_matrix = confusion_matrix(y_test, lr.predict(x_test))
plt.figure(figsize=(10, 8))
plot_confusion_matrix(cnf_matrix, classes = classes, title='Confusion matrix')
report = classification_report(y_test, lr.predict(x_test), target_names = classes)
print(report)
plt.show()




        
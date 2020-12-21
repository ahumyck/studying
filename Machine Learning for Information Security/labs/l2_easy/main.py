import pandas as pd

from sklearn.feature_extraction.text import CountVectorizer

from sklearn.metrics import confusion_matrix
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report


data_source = "spam.csv"

df = pd.read_csv(data_source, encoding = 'cp1251')
messages = df['v2'].values

vectorizer = CountVectorizer()
x = vectorizer.fit_transform(messages)
y = df['v1'].map({'spam' : 1, 'ham' : -1}).values

x_train, x_test, y_train, y_test = train_test_split(x, y, test_size = 0.5, random_state = 42)
    
lr = LogisticRegression(random_state = 42)
lr.fit(x_train, y_train)
    
classes = ['Spam', 'Ham']

cnf_matrix = confusion_matrix(y_test, lr.predict(x_test))
print(cnf_matrix)
report = classification_report(y_test, lr.predict(x_test), target_names = classes)
print(report)




        

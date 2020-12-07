import pandas as pd

from sklearn.feature_extraction.text import CountVectorizer

from sklearn.metrics import confusion_matrix
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report


data_source = "spam.csv"

data = pd.read_csv(data_source, encoding = 'cp1251') # читаем информацию из файла

#разделяем информацию из файла на тип сообщения (spam или ham) и сообщения
#преобразовываем spam к 1, а ham к -1
message_type, messages = data['v1'].map({'spam' : 1, 'ham' : -1}).values, data['v2'].values

vectorizer = CountVectorizer() #создаем объект CountVectorizer из библиотеки sklearn
x = vectorizer.fit_transform(messages) #получаем матрицу x для анализа
y = message_type # массив y результатов


#делим выборку на тестовые и тренировочные данные
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size = 0.5, random_state = 42)
    
lr = LogisticRegression(random_state = 42) # строим обучающую модель
lr.fit(x_train, y_train) # тренируем её
    
classes = ['Spam', 'Ham'] # наши классы

cnf_matrix = confusion_matrix(y_test, lr.predict(x_test)) # матрица результатов
print(cnf_matrix)
report = classification_report(y_test, lr.predict(x_test), target_names = classes) # отчет результата классификации
print(report)




        

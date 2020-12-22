import pandas as pd

from sklearn.feature_extraction.text import CountVectorizer

from sklearn.metrics import confusion_matrix
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report


data_source = "spam.csv"

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

df = pd.read_csv(data_source, encoding = 'cp1252')
messages = df['v2'].values
df['v2'] = df['v2'].apply(spacy_tokenizer)

# <----------------------------------------------------------------->

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




        

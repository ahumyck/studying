import pandas as pd
import numpy as np

fakeDataFilename = "data_fake.txt"
trueDataFilename = "data_true.txt"
dataFilename = "data.txt"
outputFilename = "output.txt"


def getData(filename):
    return pd.read_csv(filename, header = None)[0].values

def getUserNameAndActionSequence(user):
    userName, array = user.split(':')
    return userName, np.array(array.split(';'), dtype = np.uintc)

def getState(sequence, index):
    return sequence[index], sequence[index + 1]

def createBehaviorModel(actionSequence):
    behaviorModel = dict()
    N = len(actionSequence)
    
    for i in range(N - 1):
        state = getState(actionSequence, i)
        
        if state in behaviorModel:
            behaviorModel[state] += 1
        else:
            behaviorModel[state] = 1
    
    for key in behaviorModel:
        behaviorModel[key] /= (N - 1)
    
    return behaviorModel

def userBehaviourVerification(behaviourModel, userActionSequence, 
                              confidenceInterval = (0.18, 0.5)):
    def _in(value, confidenceInterval):
        a, b = confidenceInterval
        return a <= value and value <= b
    
    N = len(userActionSequence)
    howMany = 0
    
    result = ""
    for i in range(N - 1):
        state = getState(userActionSequence, i)
        
        message = ''
        if state in behaviourModel:
            probability = behaviourModel[state]
            if not _in(probability, confidenceInterval):
                howMany += 1
                message = 'Аномалия!!! Вероятность перехода: {}, интервал: {}, действия: {}\n'.format(probability, confidenceInterval, state)
        else:
            message = 'Пользователь раньше никогда не совершал последовательность действий: {}\n'.format(state)
            howMany += 1
        
        result += message
    
    return howMany, result
            
            
def main():   
    def verification(model, data, index):
        _, sequence = getUserNameAndActionSequence(data[index])
        return userBehaviourVerification(model, sequence)
    
    def buildMessage(source, name, message, counter, template):
        source += 'Проверяем пользователя {}: {} data\n'.format(name, template)
        source += message
        source += 'Количество аномалий: {}\n'.format(counter)
        return source
    
    learningData = getData(dataFilename)
    trueData = getData(trueDataFilename)
    fakeData = getData(fakeDataFilename)
    
    message = ""
    
    for i in range(len(learningData)):
        userName, userLearningSequence = getUserNameAndActionSequence(learningData[i])
        userBehaviourModel = createBehaviorModel(userLearningSequence)
        
        howManyTrue, trueMessages = verification(userBehaviourModel, trueData, i)
        howManyFake, fakeMessages = verification(userBehaviourModel, fakeData, i)
        
        resultMessage = ""
        resultMessage = buildMessage(resultMessage, userName, trueMessages, howManyTrue, 'true')
        resultMessage += '\n'
        resultMessage = buildMessage(resultMessage, userName, fakeMessages, howManyTrue, 'false')
        resultMessage += "\n\n\n"
        
        message += resultMessage
    
    f = open(outputFilename, 'w')
    f.write(message)
    f.close()
        
    

main()


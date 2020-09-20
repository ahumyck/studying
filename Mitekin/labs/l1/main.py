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
    
    result = ''
    for i in range(N - 1):
        state = getState(userActionSequence, i)
        
        message = ''
        if state in behaviourModel:
            probability = behaviourModel[state]
            if not _in(probability, confidenceInterval):
                howMany += 1
                message = 'Anomaly: probability = {}, interval = {}, state = {}\n'.format(probability, confidenceInterval, state)
        else:
            message = 'The user has never performed this sequence of actions before: {}\n'.format(state)
            howMany += 1
        
        result += message
    
    return howMany, result
            
            
def main():   
    def verification(model, data, index):
        _, sequence = getUserNameAndActionSequence(data[index])
        return userBehaviourVerification(model, sequence)
    
    def buildMessage(source, dataType, verificationInformation):
        dataTypeCounter, message = verificationInformation
        source += 'data {}\n'.format(dataType)
        source += message
        source += 'Number of anomalies: {}\n'.format(dataTypeCounter)
        return source
    
    def getMessage(userName, userBehaviourModel, data, index):
        trueData, fakeData = data
        resultMessage = ""
        resultMessage = userName + " behaviour model: " + str(userBehaviourModel) + '\n'
        resultMessage = buildMessage(resultMessage, 'true', verification(userBehaviourModel, trueData, i))
        resultMessage += '\n'
        resultMessage = buildMessage(resultMessage, 'false', verification(userBehaviourModel, fakeData, i))
        resultMessage += "\n\n\n"
        return resultMessage
        
    
    learningData = getData(dataFilename)
    data = (getData(trueDataFilename), getData(fakeDataFilename))
    
    message = ""
    
    for i in range(len(learningData)):
        userName, userLearningSequence = getUserNameAndActionSequence(learningData[i])
        userBehaviourModel = createBehaviorModel(userLearningSequence)
        message += getMessage(userName, userBehaviourModel, data, i)
    

    f = open(outputFilename, 'w')
    f.write(message)
    f.close()
        
    

main()


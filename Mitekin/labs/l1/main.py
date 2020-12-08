import pandas as pd
import numpy as np


fakeDataFilename = "data_fake.txt"
trueDataFilename = "data_true.txt"
dataFilename = "data.txt"
outputTrueFilename = "outputTrue.txt"
outputFakeFilename = "outputFake.txt"


def getData(filename) -> np.array:
    return pd.read_csv(filename, header = None)[0].values

def getUserNameAndActionSequence(user) -> (str, np.array):
    userName, array = user.split(':')
    return userName, np.array(array.split(';'), dtype = np.uintc)

def getState(sequence, index) -> tuple:
    return sequence[index], sequence[index + 1]

def createBehaviorModel(actionSequence) -> dict:
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

def checkUserBehaviour(userBehaviourModel, userActionSequence):
    
    product = 1
    
    for i in range(len(userActionSequence) - 1):
        state = getState(userActionSequence, i)
        
        if state in userBehaviourModel:
            product *= userBehaviourModel[state]
        else:
            product = -1
            break
    
    return product


            
            
def main():
    learningData = getData(dataFilename)
    trueData = getData(trueDataFilename)
    fakeData = getData(fakeDataFilename)
    
    output = dict()
    output["fake"] = ""
    output["true"] = ""
    
    for i in range(len(learningData)):
        userName, userLearningSequence = getUserNameAndActionSequence(learningData[i])
        _, trueLearningSequence = getUserNameAndActionSequence(trueData[i])
        _, fakeLearningSequence = getUserNameAndActionSequence(fakeData[i])
        
        trainingUserBehaviourModel = createBehaviorModel(userLearningSequence)
        checkedTrueUserBehaviour = checkUserBehaviour(trainingUserBehaviourModel, trueLearningSequence)
        output["true"] += "{} actions result = {}({})\n".format(userName, checkedTrueUserBehaviour > 0.1, checkedTrueUserBehaviour)
        
        checkedFalseUserBehaviour = checkUserBehaviour(trainingUserBehaviourModel, fakeLearningSequence)
        output["fake"] += "{} actions result = {}({})\n".format(userName, checkedFalseUserBehaviour > 0.1, checkedFalseUserBehaviour)
        
        


    f = open(outputTrueFilename, 'w')
    f.write(output["true"])
    f.close()  
      
    f = open(outputFakeFilename, 'w')
    f.write(output["fake"])
    f.close()  
    
main()
        
        
    
    
    



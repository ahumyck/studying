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

def compareBehaviorModels(trainingModel: dict, actualModel: dict) -> str:
    
    def completeActualModel(trainingModel: dict, actualModel: dict):
        for key in trainingModel:
            if key not in actualModel:
                actualModel[key] = 0
        return actualModel
    
    def remapTrainingModel(trainingModel: dict, actualModel: dict) -> dict:
        summ = 0
        for key in actualModel:
            if key in trainingModel:
                summ += trainingModel[key]
                
        remappedModel = dict()
        for key in actualModel:
            if key in trainingModel:
                remappedModel[key] = trainingModel[key] / summ
        return remappedModel
        
            
    
    def _in(value_a, value_b, delta = 0.1) -> bool:
        return abs(value_a - value_b) < delta
    
    message = ""
    template = "{}: action: {}, training {} vs actual {} vs remap {}\n"
    #actualModel = completeActualModel(trainingModel, actualModel)
    remappedModel = remapTrainingModel(trainingModel, actualModel)
    for key in actualModel:
        if key not in trainingModel:
            message += "The user has never performed this sequence of actions before {}\n".format(key)
        else:
            trainingValue = trainingModel[key]
            actualValue = actualModel[key]
            remappedValue = remappedModel[key]
            
            if _in(trainingValue, actualValue):
                message += template.format("True", key, trainingValue, actualValue, remappedValue)
            else:
                message += template.format("False", key, trainingValue, actualValue, remappedValue)
    
    return message + "\n\n"
            
            
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
        trueUserBehaviourModel = createBehaviorModel(trueLearningSequence)
        fakeUserBehaivourModel = createBehaviorModel(fakeLearningSequence)
        
        output["true"] += "Analyzing user = {}\n".format(userName)
        output["fake"] += "Analyzing user = {}\n".format(userName)
        output["true"] += compareBehaviorModels(trainingUserBehaviourModel, trueUserBehaviourModel)
        output["fake"] += compareBehaviorModels(trainingUserBehaviourModel, fakeUserBehaivourModel)


    f = open(outputTrueFilename, 'w')
    f.write(output["true"])
    f.close()  
      
    f = open(outputFakeFilename, 'w')
    f.write(output["fake"])
    f.close()  
    
main()
        
        
    
    
    



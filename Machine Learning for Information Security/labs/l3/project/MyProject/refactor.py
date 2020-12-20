# -*- coding: utf-8 -*-
"""
Created on Tue Dec 15 01:35:19 2020

@author: ahumy
"""

import pandas as pd

columns_name = ["Index", "x_right", 
                "y_bottom", "x_left", 
                "y_top", "ID", "frame"]

def refactor(dataFrame):
    data = pd.read_csv(trajectories_filename)
    data = data['Index;x_right;y_bottom;x_left;y_top;ID;frame']
    
    
    outputDataFrame = {
        "Index": [],
        "x_right": [],
        "y_bottom": [],
        "x_left": [],
        "y_top": [],
        "ID": [],
        "frame": []
    }
    
    for i in data:
        row_info = i.split(";")
        
        for i, column_name in enumerate(columns_name):
            outputDataFrame[column_name].append(int(row_info[i], base = 10))
    
    return pd.DataFrame(outputDataFrame, columns = columns_name)
        
trajectories_filename = "trajectories.csv"
df = refactor(pd.read_csv(trajectories_filename))
df.to_csv("refactor.csv", index = False)
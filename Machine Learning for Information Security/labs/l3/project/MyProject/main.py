# -*- coding: utf-8 -*-
"""
Created on Tue Dec 15 01:19:10 2020

@author: ahumy
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import cv2
from base_object import BaseObject


def parse_df(df):
    def create_objects(ids):
        objects = dict()
        
        for Id in ids:
            objects[Id] = BaseObject(Id)
            
        return objects
    
    objects = create_objects(df['ID'].unique())

    for index, row in df.iterrows():
        x_right, y_bottom, x_left, y_top = row['x_right'], row['y_bottom'], row['x_left'], row['y_top'] 
        objects[row['ID']].add_coordinate(x_right, y_bottom, x_left, y_top)
        
    return objects


def task_template(task_function, task_args, task_name):
    with open(task_name, "w") as f:
        f.write(task_function(task_args))
        
def task1(args):
    objects = args[0]
    window_size = args[1]
    result = ""
    for ID in objects:
        obj = objects[ID]
        obj_window_size = obj.get_window_size()
        result += "object {} has obj_ws = {}({}): {}\n".format(ID, obj_window_size, window_size,
                                    "More "if  obj_window_size > window_size else "Less or equal")
    return result


def task2(args):
    objects = args[0]
    speed = args[1]
    result = ""
    for ID in objects.keys():
        obj = objects[ID]
        obj_speed = obj.get_speed()
        result += "object {} has obj_speed = {}({}): {}\n".format(ID, obj_speed, speed,
                                    "More "if  obj_speed > speed else "Less or equal")
    return result

def task3(args):
    objects = args[0]
    coordinates = args[1]
    result = ""
    for ID in objects:
        index, coordinate = objects[ID].was_inside(coordinates)
        result += "object {} was inside of rect {}({}({})), object path = {}: \n".format(
                                     ID, 
                                     coordinates, 
                                     coordinate,
                                     index,
                                     objects[ID].get_coordinates())
    return result

def task4(args):
    objects = args[0]
    N = args[1]
    result = ""
    for ID in objects:
        obj = objects[ID]
        coordinates = obj.get_coordinates()
        cnt = 0
        for i in range(len(coordinates) - 1):
            x_right, y_bottom, x_left, y_top = coordinates[i]
            x_r, y_b, x_l, y_t = coordinates[i + 1]
            if x_r == x_right and y_b == y_bottom and x_left == x_l and y_top == y_t:
                cnt += 1
            else:
                cnt = 0
        result += "object {} was {} inactive for more than {}({}) frames\n".format(
            ID, "" if cnt >= N else "not", N, cnt)
    return result
                
            
        
    
    
def task5(args):
    df = args[0]
    N = args[1]
    unique, counts = np.unique(df['frame'], return_counts=True)
    counter = dict(zip(unique, counts))
    
    result = ""
    cnt = 1
    for key in counter:
        result += "frame {} has {} objects (th = {})\n".format(cnt, counter[key], N)
        cnt += 1
    return result

def task6(df):
    frames = df['frame'].unique()
    diff_frames = np.diff(frames)
    indecies = np.where(diff_frames > 1)   
    
    mf = []
    missing_frames = dict(zip(frames[indecies], diff_frames[indecies] - 1))
    for key in missing_frames:
        start = key + 1
        count = missing_frames[key]
        
        cnt = 0
        while cnt < count:
            mf.append(start)
            start += 1
            cnt += 1
            
    return "{}".format(mf)
        
def task7(objects):
    lifecycle = np.array([len(objects[ID].get_coordinates()) for ID in objects])
    return "Avg lifecycle = {}\n".format(np.mean(lifecycle))


def task8(objects, scene):
    coord = []
    w, h, _ = scene.shape
    for ID in objects:
        obj = objects[ID]
        coord.extend(obj.get_coordinates())
        
    heatmap = np.zeros((w, h))
    for x_right, y_bottom, x_left, y_top in coord:
        heatmap[x_left: x_right, y_top: y_bottom] += 1
        
    
    
    #heatmapshow = None
    #heatmap = cv2.cvtColor(heatmap, cv2.COLOR_RGB2BGR)
   
    #cv2.imshow("Heatmap", heatmap)
    #cv2.waitKey(0)
    
    
    
    
    
    
if __name__ == "__main__":
    trajectories_filename = "refactor.csv"
    df = pd.read_csv(trajectories_filename)
    objects = parse_df(df)
    #task_template(task1, (objects, 5000), "task1.txt")
    #task_template(task2, (objects, 5), "task2.txt")
    #task_template(task3, (objects, (500, 500, 0, 0)), "task3.txt")
    #task_template(task4, (objects, 3), "task4.txt")
    #task_template(task5, (df, 5), "task5.txt")
    #task_template(task6, df, "task6.txt")
    #task_template(task7, objects, "task7.txt")
    task8(objects, cv2.imread("scene.jpg"))
    
    


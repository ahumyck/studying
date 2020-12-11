# -*- coding: utf-8 -*-
"""
Created on Fri Dec 11 03:03:55 2020

@author: ahumy
"""

import distorsion
import matplotlib.pyplot as plt
import pickle

def load_pickle(name):
    with open(name + '.pkl', 'rb') as f:
        return pickle.load(f)

class DependencyChartBuilder():
    
    def __init__(self, result):
        self.area, self.jpeg, self.median, self.sharpering = self.__parse_results__(result)
    
    def __parse_results__(self, results):
        area = dict()
        jpeg = dict()
        median = dict()
        sharpering = dict()
        
        for wm_name in results:
            if "area" in wm_name:
                area.update(self.__parse_key__(distorsion.AreaDistorsion(), wm_name, results[wm_name]))
            if "jpeg" in wm_name:
                jpeg.update(self.__parse_key__(distorsion.JpegDistorsion(), wm_name, results[wm_name]))
            if "median" in wm_name:
                median.update(self.__parse_key__(distorsion.MedianFilterDistorsion(), wm_name, results[wm_name]))
            if "sharpering" in wm_name:
                sharpering.update(self.__parse_key__(distorsion.SharperingDistorsion(), wm_name, results[wm_name]))
            
        
        return area, jpeg, median, sharpering
    
    def __parse_key__(self, distorsion, key, value):
        start, stop, step = distorsion.get_parameters()
        index = self.__get_number_from_string__(key)
        return { round(start + index * step, 1) : value}
    
    def __get_number_from_string__(self, string):
        return [int(s) for s in string if s.isdigit()][0]
    
    def __draw_subplot__(self, points, title):
        fig, ax = plt.subplots()
        x = list(points.keys())
        y = [float(i) for i in list(points.values())]
        plt.axis([ 0.9 * min(x), 1.1 * max(x), 0.9 * min(y), 1.1 * max(y)])
        ax.scatter(x, y)
        ax.set_title(title)
        ax.set(xlabel='parameters', ylabel = 'watermart comparasion')
        plt.show()
        
    
    def draw(self):
        self.__draw_subplot__(self.area, 'Area Distrosion Result')
        self.__draw_subplot__(self.jpeg, 'Jpeg Distrosion Result')
        self.__draw_subplot__(self.median, 'Median Distrosion Result')
        self.__draw_subplot__(self.sharpering, 'Sharpering Distrosion Result')
    

if __name__ == "__main__":
    charts = DependencyChartBuilder(load_pickle("result"))
    charts.draw()
        


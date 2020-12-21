# -*- coding: utf-8 -*-

import numpy as np

class BaseObject():
    def __init__(self, ID):
        self.ID = ID
        self.coordinates = []
        
    def add_coordinate(self, x_right, y_bottom, x_left, y_top):
        self.coordinates.append((x_right, y_bottom, x_left, y_top))
        
    def get_coordinates(self):
        return self.coordinates
    
    
    def get_window_size(self, method = np.median):
        window_sizes = np.array([(x_left - x_right) * (y_top - y_bottom) 
                                for x_right, y_bottom, x_left, y_top in self.coordinates])
        return method(window_sizes)
    
    def get_speed(self, method = np.median):
        coordinates_2d = [(x_right/2 + x_left/2, y_top/2 + y_bottom/2)
                       for x_right, y_bottom, x_left, y_top in self.coordinates]
        
        speeds = np.array([])
        
        for i in range(len(coordinates_2d) - 1):
            x2, y2 = coordinates_2d[i + 1]
            x1, y1 = coordinates_2d[i]
            speeds = np.append(speeds, np.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)))
            
        return method(speeds)
    
    def was_inside(self, coordinates):
        x_right, y_bottom, x_left, y_top = coordinates
        
        rating = np.array([])
        
        for x_r, y_b, x_l, y_t in self.coordinates:
            if x_left <= x_l and x_r <= x_right:
                if y_top <= y_t and y_b <= y_bottom:
                    rating = np.append(rating, 1)
            rating = np.append(rating, 0)

        where = np.where(rating == 1)[0]
        if where.size != 0:
            return where[0], self.coordinates[where[0]]
        return -1, -1
    
                       
        
    
    def __str__(self):
        return "BaseObject: id = {}, coord = {}\n".format(self.ID, self.coordinates)
    
    def __repr__(self):
        return self.__str__()
        
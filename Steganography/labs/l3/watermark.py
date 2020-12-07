# -*- coding: utf-8 -*-
"""
Created on Mon Nov 30 16:50:02 2020

@author: ahumy
"""

import os

class Watermark():
    
    WANG = "wang"
    CORVI = "corvi"
    COX = "cox"
    
    def __init__(self, embed_type):
        self.path = os.path.abspath(os.getcwd())
        paths = self.__get_utils_and_resources__()
        self.resources = paths["resources"]
        self.utils = paths["utils"]
        self.embed_type = embed_type
        
    def __fast_scandir__(self, dirname):
        subfolders= [f.path for f in os.scandir(dirname) if f.is_dir()]
        for dirname in list(subfolders):
            subfolders.extend(self.__fast_scandir__(dirname))
        return subfolders
        
    def __get_utils_and_resources__(self):
        paths = dict()
        subfolders = self.__fast_scandir__(self.path)
        for subfolder in subfolders:
            if subfolder.endswith("utils"):
                paths["utils"] = subfolder
            if subfolder.endswith("resources"):
                paths["resources"] = subfolder
        return paths

    def embed(self, input_filename, output_filename):
        os.chdir(self.utils)
        ifn = os.path.join(self.resources, input_filename)
        ofn = os.path.join(self.resources, output_filename)
        esn = os.path.join(self.utils, self.embed_type + ".sig")
        execute = os.path.join(self.utils, "gen_" + self.embed_type + "_sig -o " + esn)
        os.system(execute)
        execute = os.path.join(self.utils, "wm_" + self.embed_type + "_e -s " + esn + " -o " + ofn + " " + ifn)
        os.system(execute)
        os.chdir(self.path)
        return esn
        
    def extract(self, working_dir, original_filename, embedded_filename, output_filename):
        os.chdir(self.utils)
        ifn = os.path.join(self.resources, original_filename)
        efn = os.path.join(working_dir, embedded_filename)
        ofn = os.path.join(working_dir, output_filename)
        esn = os.path.join(self.utils, self.embed_type + ".sig")
        execute = os.path.join(self.utils, "wm_" + self.embed_type + "_d -s " + esn + " -i " + ifn + " -o " + ofn + " " + efn)
        os.system(execute)
        os.chdir(self.path)
        
    

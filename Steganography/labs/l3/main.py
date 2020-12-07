# -*- coding: utf-8 -*-
"""
Created on Sun Nov 29 22:56:36 2020

@author: ahumy
"""

import os
import netpbmfile
import distorsion

import cv2
from PIL import Image
from watermark import Watermark
from distorsion_manager import AreaDistorsionManager, BaseDistorsionManager, JpegDistorsionManager

original_image = "peppers.pgm"
embedded_image = "embedded.pgm"

class Manager():
    
    AREA_DIR = "area"
    JPEG_DIR = "jpeg"
    MEDIAN_DIR = "median"
    SHARPERING_DIR = "sharpering"
    RESOURCES_DIR = "resources"
    MANAGER_DIR = "current"
        
    def __init__(self, watermark):
        self.paths = dict()
        self.paths[Manager.MANAGER_DIR] = os.path.abspath(os.getcwd())        
        self.paths.update(self.__get_directories__())
        self.templates = self.__init_templates__()
        self.wm = watermark
    
    def __fast_scandir__(self, dirname):
        subfolders= [f.path for f in os.scandir(dirname) if f.is_dir()]
        for dirname in list(subfolders):
            subfolders.extend(self.__fast_scandir__(dirname))
        return subfolders
    
    def __get_directories__(self):
        endings = [Manager.AREA_DIR, Manager.JPEG_DIR, Manager.MEDIAN_DIR, Manager.SHARPERING_DIR, 
                   Manager.RESOURCES_DIR]
        paths = dict()
        subfolders = self.__fast_scandir__(self.paths[Manager.MANAGER_DIR])
        for subfolder in subfolders:
            for ending in endings:
                if subfolder.endswith(ending):
                    paths[ending] = subfolder
        return paths
    
    def __init_templates__(self):
        templates = dict()
        templates[Manager.AREA_DIR] = "area_image{}.pgm"
        templates[Manager.JPEG_DIR] = "jpeg_image{}.pgm"
        templates[Manager.MEDIAN_DIR] = "median_image{}.pgm"
        templates[Manager.SHARPERING_DIR] = "sharpering_image{}.pgm"
        return templates
    
    def watermark_image(self, input_filename, output_filename):
        self.watermark_path = self.wm.embed(input_filename, output_filename)
        
    
    def area_distorsion(self, original_image_filename, embedded_image_filename):
        embedded_image = netpbmfile.imread(os.path.join(self.paths[Manager.RESOURCES_DIR], embedded_image_filename))
        original_image = netpbmfile.imread(os.path.join(self.paths[Manager.RESOURCES_DIR], original_image_filename))
        
        dist = distorsion.AreaDistorsion()
        dist_manager = AreaDistorsionManager(dist)
        
        wm_template = "area_wm{}.wm"
        area_dir = self.paths[Manager.AREA_DIR]
        for i, dist_image in enumerate(dist_manager.apply(original_image, embedded_image)):
            image_name = self.templates[Manager.AREA_DIR].format(i)
            
            netpbmfile.imwrite(os.path.join(area_dir, image_name), dist_image)
            self.wm.extract(area_dir, original_image_filename, image_name, wm_template.format(i))
            
    def jpeg_distorsion(self, origin_image_filename, embedded_image_filename):
        embedded_image = Image.open(os.path.join(self.paths[Manager.RESOURCES_DIR], embedded_image_filename))
        
        dist_manager = JpegDistorsionManager()
        wm_template = "jpeg_wm{}.wm"
        image_template = self.templates[Manager.AREA_DIR]
        
        jpeg_dir = self.paths[Manager.JPEG_DIR]
        image_template_jpeg = os.path.join(jpeg_dir, "jpeg_image{}.jpg")
        for i, quality_val in enumerate(dist_manager.parameters()):
            image_name_jpeg = image_template_jpeg.format(i)
            embedded_image.save(image_name_jpeg, 'JPEG', quality = quality_val)
            
            cv2_image = cv2.imread(image_name_jpeg)
            cv2.imwrite("", cv2_image, (cv2.CV_IMWRITE_PXM_BINARY, 0))
            
            

            
    def __base_distorsion__(self, original_image_filename, embedded_image_filename, dist, wm_template, working_dir, image_template):
        embedded_image = netpbmfile.imread(os.path.join(self.paths[Manager.RESOURCES_DIR], embedded_image_filename))
        
        dist_manager = BaseDistorsionManager(dist)
        
        for i, dist_image in enumerate(dist_manager.apply(embedded_image)):
            image_name = image_template.format(i)
            
            netpbmfile.imwrite(os.path.join(working_dir, image_name), dist_image)
            self.wm.extract(working_dir, original_image_filename, image_name, wm_template.format(i))
            
    
            
    
    def sharpering_distorsion(self, original_image_filename, embedded_image_filename):
        self.__base_distorsion__(original_image_filename, embedded_image_filename, 
                                 distorsion.SharperingDistorsion(), "sharpering_wm{}.wm", 
                                 self.paths[Manager.SHARPERING_DIR], self.templates[Manager.SHARPERING_DIR])
        
    def median_distorsion(self, original_image_filename, embedded_image_filename):
        self.__base_distorsion__(original_image_filename, embedded_image_filename, 
                                 distorsion.MedianFilterDistorsion(), "median_wm{}.wm", 
                                 self.paths[Manager.MEDIAN_DIR], self.templates[Manager.MEDIAN_DIR])


manager = Manager(Watermark(Watermark.WANG))
manager.watermark_image(original_image, embedded_image)
manager.area_distorsion(original_image, embedded_image)
manager.sharpering_distorsion(original_image, embedded_image)
manager.median_distorsion(original_image, embedded_image)
manager.jpeg_distorsion(original_image, embedded_image)

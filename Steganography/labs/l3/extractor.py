# -*- coding: utf-8 -*-
"""
Created on Fri Dec 11 02:59:30 2020

@author: ahumy
"""

import os
import netpbmfile
import distorsion

import cv2
from PIL import Image
from distorsion_manager import AreaDistorsionManager, BaseDistorsionManager, JpegDistorsionManager

class WatermarkDistorsionedImageExtractor():
    
    AREA_DIR = "area"
    JPEG_DIR = "jpeg"
    MEDIAN_DIR = "median"
    SHARPERING_DIR = "sharpering"
    RESOURCES_DIR = "resources"
    MANAGER_DIR = "current"
        
    def __init__(self, watermark):
        self.paths = dict()
        self.paths[WatermarkDistorsionedImageExtractor.MANAGER_DIR] = os.path.abspath(os.getcwd())        
        self.paths.update(self.__get_directories__())
        self.templates = self.__init_templates__()
        self.wm_templates = self.__init_wm_templates__()
        self.wm = watermark
    
    def __fast_scandir__(self, dirname):
        subfolders= [f.path for f in os.scandir(dirname) if f.is_dir()]
        for dirname in list(subfolders):
            subfolders.extend(self.__fast_scandir__(dirname))
        return subfolders
    
    def __get_directories__(self):
        endings = [WatermarkDistorsionedImageExtractor.AREA_DIR, 
                   WatermarkDistorsionedImageExtractor.JPEG_DIR, 
                   WatermarkDistorsionedImageExtractor.MEDIAN_DIR, 
                   WatermarkDistorsionedImageExtractor.SHARPERING_DIR, 
                   WatermarkDistorsionedImageExtractor.RESOURCES_DIR]
        paths = dict()
        subfolders = self.__fast_scandir__(self.paths[WatermarkDistorsionedImageExtractor.MANAGER_DIR])
        for subfolder in subfolders:
            for ending in endings:
                if subfolder.endswith(ending):
                    paths[ending] = subfolder
        return paths
    
    def __init_templates__(self):
        templates = dict()
        templates[WatermarkDistorsionedImageExtractor.AREA_DIR] = "area_image{}.pgm"
        templates[WatermarkDistorsionedImageExtractor.JPEG_DIR] = "jpeg_image{}.pgm"
        templates[WatermarkDistorsionedImageExtractor.MEDIAN_DIR] = "median_image{}.pgm"
        templates[WatermarkDistorsionedImageExtractor.SHARPERING_DIR] = "sharpering_image{}.pgm"
        return templates
    
    def __init_wm_templates__(self):
        wm_templates = dict()
        wm_templates[WatermarkDistorsionedImageExtractor.AREA_DIR] = "area_wm{}.wm"
        wm_templates[WatermarkDistorsionedImageExtractor.JPEG_DIR] = "jpeg_wm{}.wm"
        wm_templates[WatermarkDistorsionedImageExtractor.MEDIAN_DIR] = "median_wm{}.wm"
        wm_templates[WatermarkDistorsionedImageExtractor.SHARPERING_DIR] = "sharpering_wm{}.wm"
        return wm_templates
        
    
    def watermark_image(self, input_filename, output_filename):
        self.watermark_path = self.wm.embed(input_filename, output_filename)
        
    
    def area_distorsion(self, original_image_filename, embedded_image_filename):
        embedded_image = netpbmfile.imread(os.path.join(self.paths[WatermarkDistorsionedImageExtractor.RESOURCES_DIR], embedded_image_filename))
        original_image = netpbmfile.imread(os.path.join(self.paths[WatermarkDistorsionedImageExtractor.RESOURCES_DIR], original_image_filename))
        
        dist = distorsion.AreaDistorsion()
        dist_manager = AreaDistorsionManager(dist)
        
        wm_template = self.wm_templates[WatermarkDistorsionedImageExtractor.AREA_DIR]
        area_dir = self.paths[WatermarkDistorsionedImageExtractor.AREA_DIR]
        for i, dist_image in enumerate(dist_manager.apply(original_image, embedded_image)):
            image_name = self.templates[WatermarkDistorsionedImageExtractor.AREA_DIR].format(i)
            
            netpbmfile.imwrite(os.path.join(area_dir, image_name), dist_image)
            self.wm.extract(area_dir, original_image_filename, image_name, wm_template.format(i))
            
    def jpeg_distorsion(self, original_image_filename, embedded_image_filename):
        embedded_image = Image.open(os.path.join(self.paths[WatermarkDistorsionedImageExtractor.RESOURCES_DIR], embedded_image_filename))
        
        dist_manager = JpegDistorsionManager(distorsion.JpegDistorsion())
        wm_template = self.wm_templates[WatermarkDistorsionedImageExtractor.JPEG_DIR]
        
        jpeg_dir = self.paths[WatermarkDistorsionedImageExtractor.JPEG_DIR]
        image_template_jpeg = os.path.join(jpeg_dir, "jpeg_image{}.jpg")
        image_template_pgm = os.path.join(jpeg_dir, self.templates[WatermarkDistorsionedImageExtractor.JPEG_DIR])
        for i, quality_val in enumerate(dist_manager.parameters()):
            image_name_jpeg = image_template_jpeg.format(i)
            embedded_image.save(image_name_jpeg, 'JPEG', quality = quality_val)
            
            image_name = image_template_pgm.format(i)
            cv2_image = cv2.cvtColor (cv2.imread(image_name_jpeg), cv2.COLOR_BGR2GRAY)
            cv2.imwrite(image_name, cv2_image)
            self.wm.extract(jpeg_dir, original_image_filename, image_name, wm_template.format(i))
            
            

            
    def __base_distorsion__(self, original_image_filename, embedded_image_filename, dist, wm_template, working_dir, image_template):
        embedded_image = netpbmfile.imread(os.path.join(self.paths[WatermarkDistorsionedImageExtractor.RESOURCES_DIR], embedded_image_filename))
        
        dist_manager = BaseDistorsionManager(dist)
        
        for i, dist_image in enumerate(dist_manager.apply(embedded_image)):
            image_name = image_template.format(i)
            
            netpbmfile.imwrite(os.path.join(working_dir, image_name), dist_image)
            self.wm.extract(working_dir, original_image_filename, image_name, wm_template.format(i))
            
    
            
    
    def sharpering_distorsion(self, original_image_filename, embedded_image_filename):
        self.__base_distorsion__(original_image_filename, embedded_image_filename, 
                                 distorsion.SharperingDistorsion(), 
                                 self.wm_templates[WatermarkDistorsionedImageExtractor.SHARPERING_DIR], 
                                 self.paths[WatermarkDistorsionedImageExtractor.SHARPERING_DIR], 
                                 self.templates[WatermarkDistorsionedImageExtractor.SHARPERING_DIR])
        
    def median_distorsion(self, original_image_filename, embedded_image_filename):
        self.__base_distorsion__(original_image_filename, embedded_image_filename, 
                                 distorsion.MedianFilterDistorsion(), 
                                 self.wm_templates[WatermarkDistorsionedImageExtractor.MEDIAN_DIR], 
                                 self.paths[WatermarkDistorsionedImageExtractor.MEDIAN_DIR], 
                                 self.templates[WatermarkDistorsionedImageExtractor.MEDIAN_DIR])
    
    def __prepare_result__(self, console_output):
        return console_output.decode("utf-8").rstrip()
        
    
    def compare(self):
        result = dict()
        resources_dir = self.paths[WatermarkDistorsionedImageExtractor.RESOURCES_DIR]
        for path in self.paths:
            if path == WatermarkDistorsionedImageExtractor.RESOURCES_DIR or path == WatermarkDistorsionedImageExtractor.MANAGER_DIR:
                continue
            working_dir = os.path.join(resources_dir, path)
            for i in range(10):
                watermark_filename = self.wm_templates[path].format(i)
                watermark_full_filename = os.path.join(working_dir, self.wm_templates[path].format(i))
                if os.path.isfile(watermark_full_filename):
                    result[watermark_filename] = self.__prepare_result__(self.wm.compare(watermark_full_filename))
                else:
                    break
        return result

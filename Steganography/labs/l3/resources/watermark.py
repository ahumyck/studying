# -*- coding: utf-8 -*-
"""
Created on Mon Nov 30 16:50:02 2020

@author: ahumy
"""

import os

original_image = "peppers.pgm"
embedded_image = "embed.pgm"


def embed(input_filename, output_filename, embed_type):
    sig_name = embed_type + ".sig"
    execute = "gen_" + embed_type + "_sig.exe -o " + sig_name
    print('executing:', execute)
    os.system(execute)
    execute = "wm_" + embed_type + "_e.exe -s " + sig_name + " -o " + output_filename + " " + input_filename
    print('executing:', execute)
    os.system(execute)
    
embed(original_image, embedded_image, 'wang')
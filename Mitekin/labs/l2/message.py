# -*- coding: utf-8 -*-
"""
Created on Sat Nov  7 03:44:06 2020

@author: ahumy
"""

class Message:
    SPAM = 0
    HAM = 1
    
    def __init__(self, message_type, message):
        self.type = message_type
        self.message = message
        
    def __str__(self):
        template = "{}: {}\n"
        if self.type == Message.SPAM:
            return template.format("Spam", self.message)
        return template.format("Ham", self.message)

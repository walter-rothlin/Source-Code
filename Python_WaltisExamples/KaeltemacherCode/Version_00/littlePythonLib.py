#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: littlePythonLib.py
#
# Description: Allgemeine Funktions-Library (static)
#
# Autor: Walter Rothlin
#
# History:
# 24-April-2019	Initial Version
#
# ------------------------------------------------------------------

import os
import sys
import time
import datetime

def littlePythonLib_Version():
    print("littlePythonLib: 1.0.0.0")

# Date and Timestamp
# ------------------    
def getTimestamp(preStr = "", postStr="", formatString="nice"):
    formatStr = '{:%Y-%m-%d %H:%M:%S}'
    if (formatString == ""):
        formatStr = '{:%Y%m%d%H%M%S}'
    elif (formatString == "nice"):
        formatStr = '{:%Y-%m-%d %H:%M:%S}'
        
    else:
        formatStr = formatString
    return preStr + formatStr.format(datetime.datetime.now()) + postStr

# True if (old-young > limit)
def checkTimeDifference(oldTimestamp, youngTimestamp, limit, gt=True):
    timeDiff =  youngTimestamp - oldTimestamp
    secStr = str(timeDiff)[:7]
    if (gt):
	    return (secStr > limit)
    else:
	    return (secStr < limit)
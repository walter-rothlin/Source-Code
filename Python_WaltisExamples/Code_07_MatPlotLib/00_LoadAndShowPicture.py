#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 00_LoadAndShowPicture.py
#
# Description: Lädt ein Bild und zeichnet ins Bild geometrische Figuren
#
# Autor: Walter Rothlin
#
# !!!! Falls Fehler “runtimeError: package fails to pass a sanity check”
# !!!!   check File | Settings | Python Interpreter
# !!!! 1.19.4 hat auf Windows einen Fehler!
# !!!!    pip install numpy==1.19.3
#
# History:
# 22.4.21   Walter Rothlin      Initial Version
# ------------------------------------------------------------------


import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import requests


def loadAndSaveFileFromURL(url='http://google.com/favicon.ico'):
    filename = url.split('/')[-1]
    r = requests.get(url, allow_redirects=True)
    open(filename, 'wb').write(r.content)
    return filename


# imgFileName = 'G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_07_MatPlotLib\\stinkbug.png'
# imgFileName = './stinkbug.png'
imgFileName = loadAndSaveFileFromURL('https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_07_MatPlotLib/stinkbug.png')

img = mpimg.imread(imgFileName)
height = len(img)
width = len(img[1])
farbe = len(img[1][1])

print("height   :", height)
print("width    :", width)
print("farbe    :", farbe)
print(img)

plt.imshow(img)
plt.show()

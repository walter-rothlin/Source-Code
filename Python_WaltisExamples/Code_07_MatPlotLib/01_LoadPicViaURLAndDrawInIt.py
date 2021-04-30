#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 01_LoadPicViaURLAndDrawInIt.py
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


imgFileName = loadAndSaveFileFromURL('https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_07_MatPlotLib/stinkbug.png')
img = mpimg.imread(imgFileName)
height = len(img)
width = len(img[1])
farbe = len(img[1][1])

print("height   :", height)
print("width    :", width)
print("farbe    :", farbe)
doChange = True
if (doChange):
    img[2:50, 2:80] = [1, 0.5, 0, 1]       # oranges Recheck oben links
    img[-50:-3, -100:-3] = [0, 1, 1, 0.8]  # cyan Rechteck unten rechts
    img[0:, 0:5] = [1, 0, 0, 1]            # rote y-Achse
    img[0:6, 0:] = [0, 1, 0, 1]            # gruene x-Achse
    img[0:, -7:] = [0, 0, 1, 1]            # blaue  y-Ende
    img[-8:, :] = [1, 0, 1, 1]             # mangenta x-Ende

    steigung = height / width
    # print("steigung :", steigung)
    for x in range(width-1):
        y = steigung * x
        # print(x, y, int(y))
        img[int(y), x] = [1, 1, 1, 1]

    #   img = img[:, :, 0]   #

print(img)

plt.imshow(img)
plt.show()

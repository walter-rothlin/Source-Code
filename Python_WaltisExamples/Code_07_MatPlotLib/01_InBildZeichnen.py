#!/usr/bin/python3

# !!!! Falls Fehler “runtimeError: package fails to pass a sanity check”
# 1.19.4 hat auf Windows einen Fehler!
#    pip install numpy==1.19.3


import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

imgFileName = 'G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_07_MatPlotLib\\stinkbug.png'
imgFileName = './stinkbug.png'
img = mpimg.imread(imgFileName)
height = len(img)
width = len(img[1])

print("height   :", height)
print("width    :", width)

img[2:50, 2:80] = [1, 1, 0, 1]       # gelbes Recheck oben links
img[-50:-3, -100:-3] = [0, 1, 1, 1]  # cyan Rechteck unten rechts
img[0:, 0:2] = [1, 0, 0, 1]          # rote y-Achse
img[0:2, 0:] = [0, 1, 0, 1]          # gruene x-Achse
img[0:, -2:] = [0, 0, 1, 1]          # blaue  y-Ende
img[-2:, :] = [1, 0, 1, 1]           # mangenta x-Ende


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
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
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

imgFileName = './stinkbug.png'
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

#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 00_LoadAndShowPicture.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_07_MatPlotLib/00_LoadAndShowPicture.py
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
# 22-Apr-2021   Walter Rothlin      Initial Version
# 15-Jan-2023   Walter Rothlin      Fixed problem with deprecated methods
# ------------------------------------------------------------------
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

imgFileName = './stinkbug.png'
img = mpimg.imread(imgFileName)

plt.imshow(img)
plt.show()

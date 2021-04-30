#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 00a_LoadAndShowPicture.py
#
# Description: Lädt ein Bild via eine URL und zeichnet geometrische Figuren auf dieses Bild
#
# ------------------------------------------------------------------
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

# Grösse des Bildes berechnen
height = len(img)
width = len(img[1])
print("height * width: ", height, "*", width)


# Geometrische Formen auf das Bild zeichnen
# img[0:50, 0:80] = [1, 0.5, 0, 1]       # oranges Recheck oben links
img[0:20, 0:20] = [1, 0, 0, 1]

plt.imshow(img)
plt.show()

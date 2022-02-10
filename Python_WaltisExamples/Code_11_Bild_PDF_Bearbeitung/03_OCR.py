#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 03_OCR.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_11_Bild_PDF_Bearbeitung/03_OCR.py
#
# Description: Lädt ein bild und macht in einem Bereich OCR
#
# Installationshinweis: Tesseract muss installiert sein!
#                          for Windows https://github.com/UB-Mannheim/tesseract/wiki
#
# Autor: Walter Rothlin
#
# History:
# 03-Feb-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

import matplotlib.pyplot as plt
import pytesseract
from PIL import Image, ImageFilter, ImageDraw

if __name__ == "__main__":
    filePath = "./TestInputFiles/BMS_Mathe_006.bmp"

    #                 PosX,PosY,Width,Height
    areaOfInterest = [100, 200, 100, 100]

    img = Image.open(filePath)
    plt.imshow(img)
    plt.show()

    img_crop = img.crop((areaOfInterest[0], areaOfInterest[1],
                         areaOfInterest[0] + areaOfInterest[2],
                         areaOfInterest[1] + areaOfInterest[3]))

    plt.imshow(img_crop)
    plt.show()

    d = ImageDraw.Draw(img)
    d.rectangle([areaOfInterest[0], areaOfInterest[1],
                 areaOfInterest[0] + areaOfInterest[2],
                 areaOfInterest[1] + areaOfInterest[3]], width=2, fill=None, outline=(0, 0, 0, 0))
    plt.imshow(img)
    plt.show()

    img_blur  = img_crop.filter(ImageFilter.GaussianBlur(0.8))
    plt.imshow(img_blur)
    plt.show()
    pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
    print(pytesseract.image_to_string(img_blur, config='outputbase digits'))


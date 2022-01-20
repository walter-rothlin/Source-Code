#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Remove_Duplicate_Images.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_11_Bild_PDF_Bearbeitung/Remove_Duplicate_Images
#
# Description: Löscht in einem Verzeichnis alle doppelten Bilder (Inhalt des Bildes wird verglichen)
#
# Autor: Isabel Piesbergen
#
# History:
# 14-Jan_2022   Isabel Piesbergen   Initial Version (von Piesbergen Isabel (BWI-A20))
# 20-Jan-2022   Walter Rothlin      Fixed iteration and compares each picture with each other
# ------------------------------------------------------------------
import os
from PIL import ImageStat
from PIL import Image

# original in waltiLibrary.py
def File_remove(fullFileName, verbal=True, withFullName=True):
    fname = os.path.basename(fullFileName)
    if os.path.exists(fullFileName):
        os.remove(fullFileName)
        if verbal:
            if withFullName:
                print("File {} deleted!".format(fullFileName))
            else:
                print("File {} deleted!".format(fname))

    else:
        if verbal:
            if withFullName:
                print("Die Datei {} existiert nicht".format(fullFileName))
            else:
                print("Die Datei {} existiert nicht".format(fname))

def removeImg2_ifSameAsImg1(pathToImg1, pathToImg2, doDelete = False, verbal=True):
    oneDeleted = False
    fname1 = os.path.basename(pathToImg1)
    fname2 = os.path.basename(pathToImg2)
    if verbal:
        print("Compare: ", fname1)
        print("         ", fname2)

    if pathToImg1 != pathToImg2:
        image_1 = Image.open(pathToImg1)
        bild_1 = ImageStat.Stat(image_1).mean
        image_2 = Image.open(pathToImg2)
        bild_2 = ImageStat.Stat(image_2).mean
        if bild_1 == bild_2:
            if verbal:
                print("   --> Duplicates: ", fname1)
                print("                   ", fname2)
            if len(pathToImg1) <= len(pathToImg2):
                if doDelete:
                    File_remove(pathToImg2, verbal=True, withFullName=False)
                    oneDeleted = True
            else:
                if doDelete:
                    File_remove(pathToImg1, verbal=True, withFullName=False)
                    oneDeleted = True
    else:
        if verbal:
            print(pathToImg1, "Same File-Path!!!")
    return oneDeleted

# =================================
# Main
# =================================
image_folder = r'G:\_WaltisDaten\SourceCode\GitHosted\Python_WaltisExamples\Code_11_Bild_PDF_Bearbeitung\JPG_Bilder'
ending = ".jpg"
ending = ".gif"

duplicateFound = True
while duplicateFound:
    image_files = [i for i in os.listdir(image_folder) if i.endswith(ending)]
    print("Imgages (.jpg) found ({anz:1d}):".format(anz=len(image_files)), image_files)
    duplicateFound = False
    i1 = 0
    for pic_1 in image_files[:-1]:
        i1 += 1
        for pic_2 in image_files[i1:]:
            pathToImg1 = os.path.join(image_folder, pic_1)
            pathToImg2 = os.path.join(image_folder, pic_2)
            duplicateFound = removeImg2_ifSameAsImg1(pathToImg1, pathToImg2, doDelete = True, verbal=True)
            if duplicateFound:
                break
        if duplicateFound:
            break
        print("\n")

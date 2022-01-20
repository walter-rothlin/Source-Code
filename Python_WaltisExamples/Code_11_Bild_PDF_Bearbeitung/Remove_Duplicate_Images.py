#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Remove_Duplicate_Images.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_11_Bild_PDF_Bearbeitung/Remove_Duplicate_Images.py
#
# Description: Löscht in einem Verzeichnis alle doppelten Bilder (Inhalt des Bildes wird verglichen) und auch Textdateien mit gleichem Inhalt
#
# Autor: Isabel Piesbergen
#
# History:
# 14-Jan_2022   Isabel Piesbergen   Initial Version (von Piesbergen Isabel (BWI-A20))
# 19-Jan-2022   Walter Rothlin      Fixed iteration and compares each picture with each other
# 20-Jan-2022   Walter Rothlin      Added .txt .py .jpg
# ------------------------------------------------------------------
#   To Do:
#   1) .gif ist not working
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
    fileDeleted = None
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
                    fileDeleted = pathToImg2
            else:
                if doDelete:
                    File_remove(pathToImg1, verbal=True, withFullName=False)
                    fileDeleted = pathToImg1
    else:
        if verbal:
            print(pathToImg1, "Same File-Path!!!")
    return fileDeleted


def removeTxt2_ifSameAsTxt1(pathTo1, pathTo2, doDelete = False, verbal=True):
    fileDeleted = None
    fname1 = os.path.basename(pathTo1)
    fname2 = os.path.basename(pathTo2)
    if verbal:
        print("Compare: ", fname1)
        print("         ", fname2)

    if pathTo1 != pathTo2:
        with open(pathTo1, "r", encoding='utf-8') as f:
            content_1 = f.readlines()
        with open(pathTo2, "r", encoding='utf-8') as f:
            content_2 = f.readlines()
        if content_1 == content_2:
            if verbal:
                print("   --> Duplicates: ", fname1)
                print("                   ", fname2)
            if len(pathTo1) <= len(pathTo2):
                if doDelete:
                    File_remove(pathTo2, verbal=True, withFullName=False)
                    fileDeleted = pathTo2
            else:
                if doDelete:
                    File_remove(pathTo1, verbal=True, withFullName=False)
                    fileDeleted = pathTo1
    else:
        if verbal:
            print(pathTo1, "Same File-Path!!!")
    return fileDeleted

def deleteDuplicateFile(directoryPath, fileType, doDelete=False, verbal=True):
    duplicateFound = True
    duplicates = []
    fileDeleted = None
    while duplicateFound:
        fileList = [i for i in os.listdir(directoryPath) if i.endswith(fileType)]
        print("\n\n===>> Files ({ext:1s}) found ({anz:1d}):".format(anz=len(fileList), ext=fileType), fileList)
        duplicateFound = False
        i1 = 0
        for file_1 in fileList[:-1]:
            i1 += 1
            for file_2 in fileList[i1:]:
                pathTo1 = os.path.join(directoryPath, file_1)
                pathTo2 = os.path.join(directoryPath, file_2)
                if fileType == ".jpg" or fileType == ".gif":
                    fileDeleted = removeImg2_ifSameAsImg1(pathTo1, pathTo2, doDelete=True, verbal=True)
                if fileType == ".txt" or fileType == ".py":
                    fileDeleted = removeTxt2_ifSameAsTxt1(pathTo1, pathTo2, doDelete=True, verbal=True)
                if fileDeleted is not None:
                    if fileDeleted != "":
                        duplicates.append(fileDeleted)
                    duplicateFound = True
                    break
            if fileDeleted is not None:
                break
            print("\n")

    print("===>> ", len(duplicates), "Files deleted:")
    for aSingleDuplicate in duplicates:
        print("   {fName:1s}".format(fName=os.path.basename(aSingleDuplicate)))


# =================================
# Main
# =================================
directoryList = r'G:\_WaltisDaten\SourceCode\GitHosted\Python_WaltisExamples\Code_11_Bild_PDF_Bearbeitung\JPG_Bilder'
fileTypesToCompare = [".jpg", ".txt", ".py"]

for aFileType in fileTypesToCompare:
    deleteDuplicateFile(directoryList, aFileType, doDelete = False, verbal=True)

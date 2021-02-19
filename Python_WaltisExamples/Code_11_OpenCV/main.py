import enum
import os
import shutil

import cv2
from PIL import Image
import pathlib

def convertImgType(source, destination):
    img = cv2.imread(source)
    cv2.imwrite(destination, img)

#Crops the source img and returns the cropped img as an cv2 array
def imgCrop(source, xPosStart, xWidth, yPosStart, yWidth=None):

    imgToCrop = cv2.imread(source)

    height = len(imgToCrop)
    width = len(imgToCrop[1])
    farbe = len(imgToCrop[1][1])
    print("Img info:")
    print(" height   :", height)
    print(" width    :", width)
    print(" color    :", farbe)

    #Checks the inputs parameters
    if (height < yPosStart + yWidth or width < xPosStart + xWidth):
        print("Could not Crop Img")
        return imgToCrop
    #Crops the imgToCrop
    img = imgToCrop[yPosStart: yPosStart + yWidth, xPosStart:xPosStart + xWidth]
    return img

#Crops all files in sourceFolder and saves the croped imgs in the destinationFolder as a file specified in fileType
def imgBatchCrop(sourceFolder, destinationFolder, xPosStart, xWidth, yPosStart, yWidth, fileType = ".jpg"):
    filesInFolder = os.listdir(sourceFolder)
    print("Batch crop started:")
    for file in filesInFolder:
        if( file != ".DS_Store"): #Mac OS creats a .DS_Store file which can't be cropped
            print("Cropping file: " + file)
            img = imgCrop(sourceFolder + file, xPosStart, xWidth, yPosStart, yWidth)
            print("Saving cropped file: " + destinationFolder + file[:file.index('.')] + fileType)
            cv2.imwrite(destinationFolder + file[:file.index('.')] + fileType , img)
            print("------------")

#Merges multipule .jpg img into one .pdf file
def createPdfFromImgFolder(sourceFolder, pdfName , destinationFolder):
    print("Creating .pdf from img in source folder:")
    filesInFolder = os.listdir(sourceFolder)
    filesInFolder.sort()
    imgList = []
    for file in filesInFolder:
        if (file != ".DS_Store" and file[file.index('.'):] == ".jpg" ): #Mac OS creats a .DS_Store file which can't be converted to a pdf
            image1 = Image.open(sourceFolder + file)
            img1 = image1.convert('RGB')
            print(" Appending File: " + file)
            imgList.append(img1)
    imgList[0].save(destinationFolder + pdfName + ".pdf", save_all=True, append_images=imgList[1:])
    print("File has been created" + destinationFolder + pdfName + ".pdf")

def renameFiles(sourceFolder):
    filesInFolder = os.listdir(sourceFolder)
    filesInFolder.sort()
    for aFileName in filesInFolder:
        print(aFileName)
        file_extension = pathlib.Path(aFileName).suffix
        file_name = pathlib.Path(aFileName).stem
        print("File Extension: ", file_extension)
        print("File Name: ", file_name)
        nr = file_name[file_name.index('(')+1:-1]
        nrStr = "{nr:03d}".format(nr=int(nr))

        destintion = "G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\Renamed\\BMS_Mathe_" + nrStr + file_extension
        source = "G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\" + aFileName
        print(source, " --> ", destintion)
        shutil.copyfile(source, destintion)
        print("\n")

class Split(enum.Enum):
    Vertical = 1
    Horizontal = 2


def splitImageFiles(sourceFolder, destinationFolder, splitType = None):
    filesInFolder = os.listdir(sourceFolder)
    filesInFolder.sort()
    i = 1
    for source in filesInFolder:
        imgToSplit = cv2.imread(sourceFolder + source)

        height = len(imgToSplit)
        width = len(imgToSplit[1])

        listOfImgToSave = []

        if (splitType == Split.Vertical):
            listOfImgToSave.append(imgToSplit[0:, 0:int(width / 2)])
            listOfImgToSave.append(imgToSplit[0:, int(width / 2):])
        elif (splitType == Split.Horizontal):
            listOfImgToSave.append(imgToSplit[0:int(height / 2):, 0:])
            listOfImgToSave.append(imgToSplit[int(height / 2):, 0:])
        else:
            listOfImgToSave.append(imgToSplit)

        for img in listOfImgToSave:
            fileName = destinationFolder + "BMS_Mathe_" + "{nr:03d}".format(nr=i) + ".jpg"
            cv2.imwrite(fileName, img)
            i += 1


#Test programm
#  imgBatchCrop("./TestInputFiles/", "./TestOutputFiles/", 46, 1509, 80, 1040)
#  createPdfFromImgFolder("./TestOutputFiles/", "BMS_Mathe", "./TestOutputFiles/")

# convertImgType("G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\New Picture (45).bmp", "G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\New Picture (45).jpg")
# convertImgType("G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\New Picture (46).bmp", "G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\New Picture (46).jpg")
# convertImgType("G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\New Picture (51).bmp", "G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\New Picture (51).jpg")
# convertImgType("G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\New Picture (57).bmp", "G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\New Picture (57).jpg")
# convertImgType("G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\New Picture (66).bmp", "G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\New Picture (66).jpg")
# convertImgType("G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\New Picture (67).bmp", "G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\New Picture (67).jpg")

# renameFiles("G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\AllFiles\\")


#  createPdfFromImgFolder("G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\AllFiles\\", "BMS_Mathe" , "G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\")

# splitImageFiles("G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\AllFiles_Doppelseiten\\", "G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\AllFiles_Einzelseiten\\", Split.Vertical)
# createPdfFromImgFolder("G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\AllFiles_Einzelseiten\\", "BMS_Mathe_Einzelseiten" , "G:\\_WaltisDaten\\SourceCode\\GitHosted\\Python_WaltisExamples\\Code_11_OpenCV\\TestOutputFiles\\")

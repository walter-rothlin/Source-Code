import os
import cv2
import enum
from PIL import Image
import pytesseract

class Split(enum.Enum):
    Vertical = 1
    Horizontal = 2

# Crops the source img and returns the cropped img as an cv2 array
def imgCrop(source, destinationFolder, xPosStart, xWidth, yPosStart, yWidth, fileType=".jpg", splitType = None, smartPageDetection = None):
    imgToCrop = cv2.imread(source)

    sourceFileName = (source.split('/')[-1:])[0]
    sourceFileName = sourceFileName[:sourceFileName.index('.')]

    listOfImgToSave = []

    height = len(imgToCrop)
    width = len(imgToCrop[1])
    farbe = len(imgToCrop[1][1])
    print("Cropping file: " + source)
    print("Img info:")
    print(" height   :", height)
    print(" width    :", width)
    print(" color    :", farbe)

    # Checks the inputs parameters
    if (height < yPosStart + yWidth or width < xPosStart + xWidth):
        print("Could not Crop Img")
        return
    # Crops the imgToCrop
    CroppedImg = imgToCrop[yPosStart: yPosStart + yWidth, xPosStart:xPosStart + xWidth]

    if(splitType == Split.Vertical):
        listOfImgToSave.append(CroppedImg[0:, 0:int(xWidth/2)])
        listOfImgToSave.append(CroppedImg[0:, int(xWidth / 2):])
    elif(splitType == Split.Horizontal):
        listOfImgToSave.append(CroppedImg[0:int(yWidth/2):, 0:])
        listOfImgToSave.append(CroppedImg[int(yWidth/2):, 0:])
    else:
        listOfImgToSave.append(CroppedImg)

    currentIndex = 0;
    for img in listOfImgToSave:
        print("Saving cropped file: " + destinationFolder + sourceFileName + str(currentIndex) + fileType)
        if(smartPageDetection != None):
            pageNumber = str(PageNumDetection(img, smartPageDetection))

            print("Page number found: " + pageNumber)
            if(pageNumber != ""):
                fileName = destinationFolder + "Page_" +'{:05d}'.format(int(pageNumber))  + fileType
                filesInFolder = os.listdir(destinationFolder)
                if(not(filesInFolder.__contains__(fileName))):
                    cv2.imwrite(fileName, img)
                else:
                    cv2.imwrite(destinationFolder + sourceFileName + "_" + str(currentIndex) + fileType, img)
            else:
                cv2.imwrite(destinationFolder + sourceFileName + "_" +str(currentIndex) + fileType, img)
        else:
            cv2.imwrite(destinationFolder + sourceFileName + "_" +str(currentIndex) + fileType, img)
        currentIndex = currentIndex + 1

    print("------------")


# Crops all files in sourceFolder and saves the croped imgs in the destinationFolder as a file specified in fileType
def imgBatchCrop(sourceFolder, destinationFolder, xPosStart, xWidth, yPosStart, yWidth, fileType=".jpg", splitType = None, smartPageDetection = None):
    filesInFolder = os.listdir(sourceFolder)
    print("Batch crop started:")
    for file in filesInFolder:
        if (file != ".DS_Store"):  # Mac OS creats a .DS_Store file which can't be cropped
            imgCrop(sourceFolder + file, destinationFolder, xPosStart, xWidth, yPosStart, yWidth, fileType, splitType, smartPageDetection)


# Merges multipule .jpg img into one .pdf file
def createPdfFromImgFolder(sourceFolder, pdfName, destinationFolder):
    print("Creating .pdf from img in source folder:")
    filesInFolder = os.listdir(sourceFolder)
    filesInFolder.sort()
    imgList = []
    for file in filesInFolder:
        if file != ".DS_Store" and file[file.index('.'):] == ".jpg":  # Mac OS creats a .DS_Store file which can't be converted to a pdf
            image1 = Image.open(sourceFolder + file)
            img1 = image1.convert('RGB')
            print(" Appending File: " + file)
            imgList.append(img1)
    imgList[0].save(destinationFolder + pdfName + ".pdf", save_all=True, append_images=imgList[1:])
    print("File has been created")

#Uses tesseract as OCR engine
#pytesseract wrapper for tesseract !tesseract must be installed on the machine
#Tesseract in Python documentation https://nanonets.com/blog/ocr-with-tesseract/
#Installing tesseract https://www.pyimagesearch.com/2017/07/03/installing-tesseract-for-ocr/
def PageNumDetection(OriginalImg, PageNumberPositionInImg):
    ImgOfPageNumber = OriginalImg[PageNumberPositionInImg[0]: PageNumberPositionInImg[1], PageNumberPositionInImg[2]:PageNumberPositionInImg[3]]
    custom_config = r'--oem 3 --psm 6 outputbase digits'
    pageNumber = pytesseract.image_to_string(ImgOfPageNumber, config=custom_config)
    print("Page Number found: " + str(pageNumber))
    pageNumber = pageNumber.rstrip("\f")
    pageNumber = pageNumber.rstrip("\n")
    pageNumber = pageNumber.rstrip(".")
    return pageNumber

# Test programm
imgBatchCrop("BMS_Mathe/img/Source/", "BMS_Mathe/img/Destination/", 46, 1509, 80, 1040, ".jpg", Split.Vertical, [39,53,0,1600])
#imgBatchCrop("BMS_Mathe/img/Source/", "BMS_Mathe/img/Destination/", 46, 1509, 80, 1040, ".jpg", Split.Vertical)
createPdfFromImgFolder("BMS_Mathe/img/Destination/", "myNewBook", "BMS_Mathe/img/Destination/")

import cv2
import pytesseract


def imgCrop(source, xPosStart, xWidth, yPosStart, yWidth):

    imgToCrop = cv2.imread(source)

    height = len(imgToCrop)
    width = len(imgToCrop[1])
    farbe = len(imgToCrop[1][1])
    print("Img info:")
    print(" height   :", height)
    print(" width    :", width)
    print(" color    :", farbe)

    #Checks the inputs parameters
    if (height < yPosStart + yWidth) or (width < xPosStart + xWidth):
        print("Could not Crop Img")
        return imgToCrop
    #Crops the imgToCrop
    img = imgToCrop[yPosStart:yPosStart + yWidth, xPosStart:xPosStart + xWidth]
    return img

def PageNumDetection(OriginalImg, PageNumberPositionInImg):
    ImgOfPageNumber = OriginalImg[PageNumberPositionInImg[0]: PageNumberPositionInImg[1], PageNumberPositionInImg[2]:PageNumberPositionInImg[3]]
    custom_config = r'--oem 3 --psm 6 outputbase digits'
    pageNumber = pytesseract.image_to_string(ImgOfPageNumber, config=custom_config)
    print("Page Number found: " + str(pageNumber))
    pageNumber = pageNumber.rstrip("\f")
    pageNumber = pageNumber.rstrip("\n")
    pageNumber = pageNumber.rstrip(".")
    return pageNumber


originalPicture = "./TestInputFiles/BMS_Mathe_006.bmp"
frame = cv2.imread(originalPicture)
cv2.imshow("Output", frame)
cv2.waitKey(0)


croppedImage = imgCrop(originalPicture, 0, 800, 0, 600)
cv2.imshow("Output", croppedImage)
cv2.imwrite("./TestOutputFiles/BMS_Mathe_006_Cropped.bmp", croppedImage)
cv2.imwrite("./TestOutputFiles/BMS_Mathe_006_Cropped.jpg", croppedImage)
cv2.waitKey(0)

print(PageNumDetection(croppedImage, [0, 30, 0, 30]))

import requests
import json
import os
from PIL import Image



def getPage(num, subfolder, booknumber):
    headers = {
        'get': 'HTTP/1.1',
        'Connection': 'keep-alive',
        'Cookie': '_ATB2Tracking_session=WmtFODFPY0tTRnJxWWVWUDE4Tmp0UG5KTlhHSXNVSVpTUE9rSzFBbUt4bFBiTDkySi9SazE5cFlVSDFZZHo4UDZHNWs4cmZ6bXlDc0hqSGluWkRWNnhMZXA1OW9FU0ZpR09Xd0xFa0FSVkFUd1VLS1FLbVRKL0VrRGlWL3JFYlVHdjVzOHRaRldGelVsT091S0Vpc1ZZaUsxMEZScmcrMXorQjVjT1BwVmQwS3ZkeCtvdlZaR0VvbW4zWmNINkdHaEVTYml6aDJiSmNKWmQrckUvYnA4TU4rc1VDUkx6OEV1U0pJUEVoWXBQQ2hYSjVTVDJkNkk0UDR2clBZV0lya0RvcjlYd0l4ZUJwN2t2RlAzaU5yc3REbENEd3cyTVBHQTlmdk5jTVFQSGc9LS14M2lyWUxKcE9vSG5oakYreXVkaTVnPT0%3D--ba0c3dc4f824106f912b847393fc847e7e0c2d09; auth_token=P3SBe-edPJaf94YgPUdw1A'
    }

    ApiEndpoint = "https://ebookx.ch/active_textbooks/" + str(booknumber) +"/pg"+ str(num) + "/large.jpg"
    r = requests.get(url=ApiEndpoint, headers=headers)
    if not os.path.exists(subfolder):
        os.mkdir(subfolder)
        print("Directory ", subfolder, " Created ")

    print("loading page number from server: " + str(num) +"\tresponse status: " + str(r.status_code))

    if r.status_code == 200:
        with open(subfolder +'/page'+ str(num).zfill(5) +'.jpg', 'wb') as f:
            f.write(r.content)

    return r.status_code


def pageCrawler(startPage, subfolder, booknumber):
    while getPage(startPage, subfolder, booknumber) == 200:
        startPage += 1

def createPdfFromImgFolder(sourceFolder, pdfName, destinationFolder):
    print("Creating .pdf from img in source folder:")

    if not os.path.exists(destinationFolder):
        os.mkdir(destinationFolder)
        print("Directory ", destinationFolder, " Created ")

    filesInFolder = os.listdir(sourceFolder)
    filesInFolder.sort()
    imgList = []
    for file in filesInFolder:
        if (file != ".DS_Store" and file[file.index('.'):] == ".jpg"):  # Mac OS creats a .DS_Store file which can't be converted to a pdf
            image1 = Image.open(sourceFolder + file)
            img1 = image1.convert('RGB')
            print(" Appending File: " + file)
            imgList.append(img1)
    imgList[0].save(destinationFolder + pdfName + ".pdf", save_all=True, append_images=imgList[1:])
    print("File has been created")

def getPdf(listOFBooks):
    print(listOFBooks[0][0])
    for book in listOFBooks:
        print("creating book: " + book[0])
        pageCrawler(1,book[0],book[1])
        createPdfFromImgFolder(book[0]+'/', book[0], outputPdf/")



mybooklist = [
    # ['Verkauf und Distribution', 443],
    # ['Marketing', 440],
    # ['Produkt-und Preisgestaltung', 441],
    # ['Marketing- und Unternehmenskommunikation', 442],
    ['Projektmangement', 444],
]

getPdf(mybooklist)

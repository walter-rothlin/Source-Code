import os
from PIL import ImageStat
from PIL import Image
from waltisLibrary import *


def removeImg2_ifSameAsImg1(pathToImg1, pathToImg2):
    if pathToImg1 != pathToImg2:
        image_1 = Image.open(pathToImg1)
        bild_1 = ImageStat.Stat(image_1).mean
        image_2 = Image.open(pathToImg2)
        bild_2 = ImageStat.Stat(image_2).mean
        if bild_1 == bild_2:
            fname1 = os.path.basename(pathToImg1)
            fname2 = os.path.basename(pathToImg2)
            print("Duplicates: ", fname1, "ist gleich", fname2)
            if len(pathToImg1) <= len(pathToImg2):
                print("\n     --> Remove", fname2, "\n\n")
                ##### File_remove(pathToImg2)
            else:
                print("\n     --> Remove", fname1, "\n\n")
                ##### File_remove(pathToImg1)
    else:
        print(pathToImg1, "Same FilePath!!!")

# image folder
image_folder = r'G:\_WaltisDaten\SourceCode\GitHosted\Python_WaltisExamples\Code_11_Bild_PDF_Bearbeitung\JPG_Bilder'
ending = ".jpg"

# looping through images in the folder and add it into list:
image_files = [i for i in os.listdir(image_folder) if i.endswith(ending)]
print("image files:", image_files)




duplicateFound=True
while duplicateFound:
    duplicateFound = False
    for pic_1 in image_files[:-1]:
        print(pic_1)
        for pic_2 in image_files[1:]:
            print("   --->", pic_2)
            pathToImg1 = os.path.join(image_folder, pic_1)
            pathToImg2 = os.path.join(image_folder, pic_2)
            removeImg2_ifSameAsImg1(pathToImg1, pathToImg2)
            duplicateFound = True
            halt()
        print("\n")

exit(0)
# store older duplicate filenames
duplicates = []

# orignial file compared to other files:
for i in image_files:
    # check if file is not in duplicate files:
    if not i in duplicates:
        bild_1_filePath = os.path.join(image_folder, i)
        image_org = Image.open(bild_1_filePath)
        bild_1 = ImageStat.Stat(image_org).mean
        print("Bild1: ", bild_1)
        print("duplicate file list 1 :", duplicates)
        print()

        for file_check in image_files:
            if file_check != i:
                bild_2_filePath = os.path.join(image_folder, file_check)
                image_check = Image.open(bild_2_filePath)
                bild_2 = ImageStat.Stat(image_check).mean
                print("Bild2: ", bild_2)
                print("duplicate file list 2 :", duplicates)
                print()

                if bild_1 == bild_2:
                    print(bild_1_filePath, "ist gleich", bild_2_filePath, "     --> Remove", bild_2_filePath)
                    duplicates.append(("i:", i, "file_check:", file_check))
                    File_remove(bild_2_filePath)
                    print()
        print("duplicate files", duplicates)
    break



import os
from tkinter import Image
from PIL import ImageStat
from PIL import Image

#image folder
image_folder = r'C:\Users\Isabel.Piesbergen\Pictures\Camera Roll'
ending = ".jpg"

#looping through images in the folder and add it into list:
image_files = [i for i in os.listdir(image_folder) if i.endswith(ending)] # os.listdir() method is used to get the list of all files and directories in the specified directory.
print("image files:",image_files)

#store older duplicate filenames
duplicates = []

#orignial file compared to other files:
for i in image_files:
    #check if file is not in duplicate files:
    if not i in duplicates:                                 #if this file is not in duplicate files
        image_org = Image.open(os.path.join(image_folder, i))    # Open an image file when the path is made from os.path.join
        bild_1 = ImageStat.Stat(image_org).mean                   #The ImageStat module calculates global statistics for an image, or for a region of an image
        print("Bild1: ", bild_1)
        print("duplicate file list 1 :",duplicates)
        print()

        for file_check in image_files:
            if file_check != i:
                image_check = Image.open(os.path.join(image_folder, file_check))
                bild_2 = ImageStat.Stat(image_check).mean
                print("Bild2: ", bild_2)
                print("duplicate file list 2 :", duplicates)
                print()

                if bild_1 == bild_2:
                    print("ist bild_1 == bild_2 ?")
                    duplicates.append(("i:",i,"file_check:",file_check))

                    #os.remove(str(bild_2)) #todo: walti Fragen, wie ich nun die Bilder auf Os löschen kann, welche i.d. Liste doppelt gefunden wurden
                    #os.remove(bild_2) for bild_2 in image_files
                    print()
        print("duplicate files",duplicates)

    break


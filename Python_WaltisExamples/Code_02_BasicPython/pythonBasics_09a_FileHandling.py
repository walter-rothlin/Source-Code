#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_09a_FileHandling.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_09a_FileHandling.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

import os
from pathlib import Path
import shutil


if __name__ == '__main__':
  testfile_1 = "./TestFile_FileHandling.txt"
  testfile_2 = "./TestFile_FileHandling_tmp.txt"

  print("\n")
  print("File write and append operations")
  print("================================")

  # testen ob file exists and than copy it
  if (os.path.exists(testfile_1)):
    print("shutil.copy(", testfile_1, ",", testfile_2, ")", sep="")
    shutil.copy(testfile_1, testfile_2)

  # save current dir
  saved_cwd = os.getcwd()
  print("saved_cwd:", saved_cwd)

  # change current directory
  os.chdir("..")
  print("current  :", os.getcwd())

  # list directory
  filesInDir = os.listdir(".")
  print(filesInDir)
  for aFile in filesInDir:
    print(aFile)

  filesInDir = os.listdir("./Code_02_BasicPython")
  print(filesInDir)

  # restore current directory
  os.chdir(saved_cwd)

  # remove file if exists
  if (os.path.exists(testfile_2)):
    os.remove(testfile_2)
    print(testfile_2, "has been deleted")
  else:
    print(testfile_2, "does not exist")

  print("More os details: https://docs.python.org/3/library/os.html")


  # path operations
  some_path = 'a/b/c/the_file.extension'
  p = Path(some_path)
  pathOnly = p.parent
  name_without_extension = p.stem
  ext = p.suffix
  print(p, '===>', "   parent:", pathOnly, "      name_without_extension:", name_without_extension, "      suffix:", ext)





  # os.rename('a.txt', 'b.kml')
  # old_file = os.path.join("directory", "a.txt")
  # new_file = os.path.join("directory", "b.kml")
  # os.rename(old_file, new_file)


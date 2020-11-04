#!/usr/bin/python3

import os
from pathlib import Path
import shutil


if __name__ == '__main__':
  testfile_1 = "./TestFile_FileHandling.txt"
  testfile_2 = "./TestFile_FileHandling_tmp.txt"

  print("\n")
  print("File operations")
  print("===============")
  os.system('copy testfile_1 testfile_2')
  if (os.path.exists(testfile_1)):
    shutil.copy(testfile_1, testfile_2)

  saved_cwd = os.getcwd()
  print("saved_cwd:", saved_cwd)

  os.chdir("..")
  print("current  :", os.getcwd())

  filesInDir = os.listdir("./Code_02_BasicPython")
  print(filesInDir)

  os.chdir(saved_cwd)

  if (os.path.exists(testfile_2)):
    os.remove(testfile_2)
    print(testfile_2, "has been deleted")
  else:
    print(testfile_2, "does not exist")

  print("More os details: https://docs.python.org/3/library/os.html")


  # os.rename('a.txt', 'b.kml')
  #
  # old_file = os.path.join("directory", "a.txt")
  # new_file = os.path.join("directory", "b.kml")
  # os.rename(old_file, new_file)


  some_path = 'a/b/c/the_file.extension'
  p = Path(some_path)
  pathOnly = p.parent
  name_without_extension = p.stem
  ext = p.suffix
  print(p, '===>', "   parent:", pathOnly, "      stem:", name_without_extension, "      suffix:", ext)

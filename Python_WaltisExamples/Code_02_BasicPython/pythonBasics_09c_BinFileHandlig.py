#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_09c_BinFileHandlig.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_09c_BinFileHandlig.py
#
# Description: Binär-File handling
#
# Help:
#   https://www.delftstack.com/de/howto/python/read-binary-files-in-python/
#
# Autor: Walter Rothlin
#
# History:
# 23-Jan-2022   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
from waltisLibrary import *

# in waltisLibrary:
# def File_getCountOfLines(sourceFileFN):
# def File_deleteLines(sourceFileFN, destinationFileFN=None, deleteLineFrom=None, deleteLineTo=None, verbal=False):


if __name__ == '__main__':
    testfile_1 = "./pythonBasics_09b_FileHandlig.py"
    testfile_2 = "./weatherLogCopy.txt"

    deleteLineFrom = 3
    deleteLineTo   = 5

    print(File_getCountOfLines(testfile_1))
    File_deleteLines(testfile_1, destinationFileFN=testfile_2)
    # File_deleteLines(testfile_1, destinationFileFN=testfile_2,                                deleteLineTo=deleteLineTo)
    # File_deleteLines(testfile_1, destinationFileFN=testfile_2, deleteLineFrom=deleteLineFrom)
    File_deleteLines(testfile_1, destinationFileFN=testfile_2, deleteLineFrom=deleteLineFrom, deleteLineTo=deleteLineTo)
    print(File_getCountOfLines(testfile_2))

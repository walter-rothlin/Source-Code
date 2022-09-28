#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_09_FileHandling.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_09_FileHandling.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 24-Dec-2022   Walter Rothlin      Initial Version
# 26-Sep-2022   Walter Rothlin      Changes for HBU
# ------------------------------------------------------------------
import os

def halt(prompt="Weiter?"):
    return input(prompt)


if __name__ == '__main__':
    testfile_1 = "./TestFile_FileHandling_UTF_8.txt"
    testfile_2 = "./TestFile_FileHandling_Default.txt"
    testfile_3 = "./TestFile_FileHandling_UTF_16.txt"

    print("File write and append operations")
    print("================================")
    print("x - Create - will create a file, returns an error if the file exist")
    print("a - Append - will create a file if the specified file does not exist")
    print("w - Write  - will create a file if the specified file does not exist")

    text_1 = "Dies ist die eine Zeile mit Umlauten äöü!!\nund dies ist auf einer neuen Zeile"

    text_2 = """
    1.Zeile     text_2
    2.Zeile     text_2
    3.Zeile     text_2
    4.Zeile     text_2
    """

    text_3 = '''1.Zeile     text_3
    2.Zeile     text_3
    '''

    text_4 = """
    Nr    |Fct                |Bitmuster    |Odd_Parity   |Param3       |Expected
         1|addParity          |1101110      |True         |0            |01101110
         2|addParity          |0101110      |True         |0            |10101110
         3|addParity          |110          |True         |0            |1110
         4|addParity          |1101110      |False        |0            |11101110
         5|addParity          |0101110      |False        |0            |00101110
         6|addParity          |110          |False        |0            |0110
    """

    f = open(testfile_1, "w", encoding='utf-8')
    f.write(text_1)
    f.close()
    print("---> ", testfile_1, " has been written")

    f = open(testfile_2, "w")
    f.write(text_1)
    f.close()
    print("---> ", testfile_2, " has been written")

    f = open(testfile_3, "w", encoding='utf-16')
    f.write(text_1)
    f.close()
    print("---> ", testfile_3, " has been written")

    halt()

    f = open(testfile_1, "w", encoding='utf-8')
    f.write(text_1)
    f.write(text_2)
    f.write(text_3)
    f.write('\n\n\n')
    f.close()
    print("---> ", testfile_1, " has been written")

    halt()

    f = open(testfile_1, "a", encoding='utf-8')
    f.write(text_4)
    f.close()
    print("---> ", testfile_1, " has been written (lines appended)")
    halt()

    print("\n\n\n\n")
    print("File read operations")
    print("====================")

    print("Anfang eines Files lesen")
    print("------------------------")
    f = open(testfile_1, "r", encoding='utf-8')
    print("Die ersten   5 Zeichen vom File:", f.read(5))
    print("Die nächsten 6 Zeichen vom File:", f.read(6))
    print("Die naechste Zeile:", f.readline(), end="")
    print("Eine weitere Zeile:", f.readline())
    f.close()
    print("---> ", testfile_1, " has been read")
    halt("11")

    print("Durch ganzes File zeilenweise loopen")
    print("------------------------------------")
    f = open(testfile_1, "r", encoding='utf-8')
    for line in f:
        print(line, end="")
    f.close()
    print("\n")
    print("---> ", testfile_1, " has been looped through read")
    halt()

    print("Ganzes File in einem readlines() lesen")
    print("--------------------------------------")
    f = open(testfile_1, "r", encoding='utf-8')
    fileContent = f.readlines()  # filecontent ist eine Liste von Zeilen mit \n am Schluss
    print(fileContent, end="")
    f.close()
    print("\n")

    print("Files lesen using with")
    print("------------------------")
    with open(testfile_1, "r", encoding='utf-8') as f:
        firstLine = f.readline()
        print(firstLine, end="")
    print("first line using with...\n")

    if os.path.exists(testfile_1):
        os.remove(testfile_1)
        print(testfile_1, "has been deleted")
    else:
        print(testfile_1, "does not exist")

    if os.path.exists(testfile_2):
        os.remove(testfile_2)
        print(testfile_2, "has been deleted")
    else:
        print(testfile_2, "does not exist")

    if os.path.exists(testfile_3):
        os.remove(testfile_3)
        print(testfile_3, "has been deleted")
    else:
        print(testfile_1, "does not exist")
    print("More os details: https://docs.python.org/3/library/os.html")

#!/usr/bin/python3
from waltisLibrary import *

if __name__ == '__main__':
  testfile_1 = "./TestFile_FileHandling.txt"

  print("File write and append operations")
  print("================================")
  print("x - Create - will create a file, returns an error if the file exist")
  print("a - Append - will create a file if the specified file does not exist")
  print("w - Write  - will create a file if the specified file does not exist")

  text_1 = "Dies ist die eine Zeile kit Umlauten äöü!!\nund dies ist auf einer neuen Zeile"

  text_2 = """1.Zeile     text_2
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
  f.write(text_2)
  f.write(text_3)
  f.close()
  print("---> ", testfile_1, " has been written")
  halt()

  f = open(testfile_1, "a", encoding='utf-8')
  f.write(text_4)
  f.close()
  print("---> ", testfile_1, " has been written (lines appended")
  halt()

  print("\n\n\n\n")
  print("File read operations")
  print("====================")

  print("Anfang eines Files lesen")
  print("------------------------")
  f = open(testfile_1, "r", , encoding='utf-8')
  print("Die ersten 5 Zeichen vom File:", f.read(5))
  print("Die ersten 6 Zeichen vom File:", f.read(6))
  print("Die naechste Zeile:", f.readline(), end="")
  print("Eine weitere Zeile:", f.readline())
  f.close()
  print("\n")

  print("Durch ganzes File zeilenweise loopen")
  print("------------------------------------")
  f = open(testfile_1, "r", encoding='utf-8')
  for line in f:
    print(line, end="")
  f.close()
  print("\n")

  print("Ganzes File in einem readlines() lesen")
  print("--------------------------------------")
  f = open(testfile_1, "r", encoding='utf-8')
  fileContent = f.readlines()
  print(fileContent, end="")
  f.close()
  print("\n")

  print("Files lesen using with")
  print("------------------------")
  with open(testfile_1, "r", encoding='utf-8') as f:
    lines = f.readlines()
  print("using with...\n", lines)


  if (os.path.exists(testfile_1)):
    os.remove(testfile_1)
    print(testfile_1, "has been deleted")
  else:
    print(testfile_1, "does not exist")

  print("More os details: https://docs.python.org/3/library/os.html")

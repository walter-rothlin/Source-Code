#!/usr/bin/python3

testfile_1 = "./TestFile_FileHandling.txt"
testfile_2 = "./TestFile_FileHandling_tmp.txt"

print("Anfang eines Files lesen")
print("------------------------")
f = open(testfile_1, "r")
print(f.read(5), end="")
print(f.readline(), end="")
print(f.readline(), end="")
f.close()
print("\n")

print("Ganzes File lesen")
print("-----------------")
f = open(testfile_1, "r")
for line in f:
  print(line, end="")
f.close()
print("\n")

print("Eine Zeile an ein File anhängen (append)")
print("----------------------------------------")
f = open(testfile_1, "a")
f.write("Now the file has more content!")
f.close()
f = open(testfile_1, "r")
print(f.read())
print("\n")

print("Ein neues File kreieren (Owerwrite)")
print("-----------------------------------")
f = open(testfile_2, "w")
f.write("x - Create - will create a file, returns an error if the file exist\n")
f.write("a - Append - will create a file if the specified file does not exist\n")
f.write("w - Write  - will create a file if the specified file does not exist\n")
f.close()
f = open(testfile_2, "r")
print(f.read())
f.close()

import os

if (os.path.exists(testfile_2)):
  os.remove(testfile_2)
  print(testfile_2, "has been deleted")
else:
  print(testfile_2, "does not exist")

print("More os details: https://docs.python.org/3/library/os.html")

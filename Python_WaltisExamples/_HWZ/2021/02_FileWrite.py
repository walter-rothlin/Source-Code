text_1 = "Hallo HWZ 2021\\nHier geht es 'auf' die nächste Zeile\n\nDann eine Leerzeile"

text_2 = '''
Hallo 'Zürich'
HWZ
'''

testFileName = "testWrite.txt"

# print("writting to file", testFileName)
# print(text_1)
#
# print("Pre:" + text_2 + ":Post")

# fileHandler = open(testFileName, 'w', encoding='utf-8')
# fileHandler.write(text_1 + "\n")
# fileHandler.write(text_2)
# fileHandler.write(text_1 + '\n')
# fileHandler.write("===========================\n")
# fileHandler.close()

# fileHandler_1 = open(testFileName, 'r', encoding='utf-8')
# print("\n\nRead from file....")
# print(fileHandler_1.read(10))
# print(fileHandler_1.readline())
# print(fileHandler_1.readline())
# fileHandler_1.close()


# fileHandler_1 = open(testFileName, 'r', encoding='utf-8')
# print("Lesen....")
# print(fileHandler_1.readline(), end="")
# print(fileHandler_1.readline(), end="")
# print(fileHandler_1.readline(), end="")
# fileHandler_1.close()

# print("Print-Befehl")
# print("neue Zeile", end='\n')
# print("neue Zeile", "weitere Wert auf gleicher Zeile", 23*4, sep='....', end="!!!!\n\n")
#
# separator = ";"
# print("Id", "Name", "Vorname", "PLZ", sep=separator)
# print(12, "Muster", "Felix", 3000, sep=separator)
# print("ende")

# f = open(testFileName, "r", encoding='utf-8')
# for line in f:
#     print(line, end="")
# f.close()

f = open(testFileName, "r", encoding='utf-8')
fileContent = f.readlines()
f.close()

print(fileContent, end="")
print("\n")

for aLine in fileContent:
    print(aLine, end="")











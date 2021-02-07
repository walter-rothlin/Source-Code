eineZeile = "Dies ist die 1.Zeile!!\naskjdkajdka"

mehrereZeilen = """shaflhaskhfjaljh
ajdfkhasldfhasljfhjals
alskdjflasfhlashf
alsdhfladfhfjh
"""

mulLines = '''ajsdhlkahsdkja
asöfkdjföjas
'''

multiLine = """
Hier sind weitere Zeilen
und noch eine!!!!
"""
print(eineZeile)

filename = "./TestFile_FileHandling.txt"

print("\nWrite file")
f = open(filename, "w")
f.write(eineZeile)
f.write(multiLine)
f.write(mulLines)
f.write(mehrereZeilen)
f.close()

print("\nRead file")
f = open(filename, "r")
geleseneZeilen = f.read(5)
print("geleseneZeilen:", geleseneZeilen)
f.close()

print("\nRead file")
f = open(filename, "r")
geleseneZeilen = f.readline()
print("geleseneZeilen:", geleseneZeilen)
geleseneZeilen = f.readline()
print("geleseneZeilen:", geleseneZeilen)
f.close()

print("\nRead file by line")
f = open(filename, "r")
for aLine in f:
    print(aLine, end="")
f.close()
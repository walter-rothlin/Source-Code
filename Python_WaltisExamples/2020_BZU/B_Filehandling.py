eineZeile = "Das ist meine 1.Zeile!!!!!"
zweiteZeile = "Das ist meine 2.Zeile!!!!!"
dritteZeile = "Das ist meine 3.Zeile!!!!!"
weitereZeilen = """1.Zeile
Zweite Zeile
Dritte Zeile
"""

filename = "test_1.txt"

print(eineZeile)
print("\nFile open for Write")
f = open(filename, "w")
f.write(eineZeile + "\n")
f.write(zweiteZeile + "\n")
f.write(weitereZeilen)
f.write(dritteZeile + "\n")
f.close()
print("File closed")

print("\n--> File open for Read")
f = open(filename, "r")
gelesenerInhalt = f.read()
print(gelesenerInhalt)
f.close()


print("\n--> File open for Read")
f = open(filename, "r")
gelesenerInhalt = f.readline()
print(gelesenerInhalt, end="")
gelesenerInhalt = f.readline()
print(gelesenerInhalt, end="")
f.close()

print("\n--> File open for Read in Loop")
f = open(filename, "r")
for aLine in f:
    print(aLine, end="")
f.close()
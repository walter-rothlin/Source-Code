# ------------------------------------------------------------------
# Name: pythonBasics_16_HexBinOct.py
#
# Description: Example to work with Hex, Bin, Oct and Dezimals
#
# Autor: Walter Rothlin
#
# History:
# 05-Nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------

def aLine(laenge=1, aChr="-"):
    return aChr * laenge

# aStr = input("Input String:")
aStr = "BZU ist in Uster!!!"
print("Input       :", aStr)

# durch String loopen
for aChr in aStr:
    print(aChr, ord(aChr), hex(ord(aChr)), bin(ord(aChr)), oct(ord(aChr)), chr(ord(aChr)+1))
print()


# subStr
print("first char:", aStr[0])
print("last  char:", aStr[-1])
print("middle    :", aStr[1:3])
print("start     :", aStr[:2])
print("start     :", aStr[-3:])

# padden
print("padden :", aStr[0])
print("padden :", aStr[0].rjust(8, "x"))
print("padden :", aStr[0].ljust(8, "y"))

print("+{z:5s}+{ordDec:3s}+{ordHex:5s}+{ordOct:6s}+{ordBin:8s}+".format(
                                                                    z=aLine(5),
                                                                    ordDec=aLine(3),
                                                                    ordHex=aLine(5),
                                                                    ordOct=aLine(6),
                                                                    ordBin=aLine(8)))

print("|{z:5s}|{ordDec:3s}|{ordHex:5s}|{ordOct:6s}|{ordBin:8s}+".format(
                                                                    z="Chr",
                                                                    ordDec="Dec",
                                                                    ordHex="Hex",
                                                                    ordOct="Oct",
                                                                    ordBin="Bin"))

print("+{z:5s}+{ordDec:3s}+{ordHex:5s}+{ordOct:6s}+{ordBin:8s}+".format(
                                                                    z=aLine(5),
                                                                    ordDec=aLine(3),
                                                                    ordHex=aLine(5),
                                                                    ordOct=aLine(6),
                                                                    ordBin=aLine(8)))
for aChr in aStr:
    i = ord(aChr)
    print("|{z:5s}|{ordDec:3d}|{ordHex:5s}|{ordOct:6s}|{ordBin:8s}|".format(
                                                                    z=chr(i),
                                                                    ordDec=i,
                                                                    ordHex=hex(i)[2:].upper(),
                                                                    ordOct=oct(i)[2:].upper().rjust(3, "0"),
                                                                    ordBin=bin(i)[2:].upper().rjust(7, "0")))
print("+{z:5s}+{ordDec:3s}+{ordHex:5s}+{ordOct:6s}+{ordBin:8s}+".format(
                                                                    z=aLine(5),
                                                                    ordDec=aLine(3),
                                                                    ordHex=aLine(5),
                                                                    ordOct=aLine(6),
                                                                    ordBin=aLine(8)))

print()


#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: pythonBasics_01_VarStringPrint.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_01_VarStringPrint.py
#
# Description: Examples of vars strings and print as well as formatted strings
#
# Autor: Walter Rothlin
#
# History:
# 03-Aug-2017   Walter Rothlin      Initial Version
# 19-Sep-2017   Walter Rothlin      Added more format string
# 26-Dec-2017   Walter Rothlin      String formats
# 28-Nov-2021   Walter Rothlin      Added f-Strings available with Python 3.6 and higher
# 04-Dec-2021   Walter Rothlin      Added Type-Hints
# 03_Jul_2022   Walter Rothlin      Added Camel, Pascal and Snake-Case
# ------------------------------------------------------------------
import sys
import os


# Variablen Namen
einWert ="Diese Variable hat einen Namen in Camel-Case"
EinWert ="Diese Variable hat einen Namen in Pascel-Case"
ein_wert ="Diese Variable hat einen Namen in Snake-Case"

# Variablen Type (nicht statische Typisierung sondern Duck-Typing (Eine Ente muss nicht angeschrieben sein, um als Ente erkannt zu werden!)
aVal = 5
aVal = 5.0
aVal = "5.0"


# Formatierung
i = 10
aString = "walti"
print(f'{aString:^30s}:{aString:>8s}:{aString:3s}:')  # available with Python 3.6 and higher
print(f"Hallo {i:20d} {i*5:_<20d}:")
print(f"Hallo {i*10:20x}")

vorname = "Walti"
print(f"hallo{vorname:_^20s}")


print("pythonBasics_01_VarStringPrint.py.........")
print("-->", sys.argv[0])
print("==>", os.path.basename(__file__))

print("# print")
print("# -----")
print("Hallo world")                   # first statement
print("Hallo", "world", "!!!")         # mehrere Argumente / Parameter
print("Hallo" + " world" + " !!!")     # Ein Argument mit String-Operationen
print("Hallo\n\nWorld")                # line-feed
print("Radius:", 5, " --> ", "Umfang:", 2*5*3.141592)      # Zahlenwerte
print("Radius:", 5, " --> ", "Umfang:", 2*5*3.141592, sep="")
print("Radius:", 5, " --> ", "Umfang:", 2*5*3.141592, sep="::")
print("Radius:", 5, " --> ", "Umfang:", 2*5*3.141592, sep="\t")
print("Radius:", 5, end="", flush=True)
print(" --> ", "Umfang:", 2*5*3.141592, sep="\t")
print("\n\n")

print("# print mit variables and string conncationation ")
print("# ---------------------------------------------- ")
name = "Rothlin"         # String
vorname: str = "Tobias"  # with Type-Hints
a, b, isFinished = 100, 5.56, False                                # int, float, boolean
print(name, vorname, a, b, isFinished)                                # einzelne Argumente Default of sep is " "
print(name + " " + vorname + " " + str(a) + " " + str(b) + " " + str(isFinished))       # string conncatination

count = 50 * 2                        # Integer type
print("Count:", count, sep=" :: ")    # einzelne Argumente Default of sep is " "
print("Count: " + str(count))         # type conversion

betrag = 2008.55                      # Float type
print("Betrag:", betrag)
print("Betrag: " + str(betrag))
print("\n\n")

print("# format ")
print("# ------ ")
betrag2 = 123476.78
print(name, count, betrag, betrag2/count, sep=" ; ")
print("123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890")
print("{p_s:8s}; ;{p_i:4d}; --> ;{p_f:12.2f};  ==> ;{p_ff:12.3f}; = ;{p_b:8s}".format(p_s=name, p_i=count, p_f=betrag, p_ff=betrag2/count, p_b=str(isFinished)))
print("\n")
print("123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890")
print("{p_s:10s}; ;{p_i:7d}; --> ;{p_f:12.2f};".format(p_s=name, p_i=count, p_f=betrag))
print("{p_s:<10s}; ;{p_i:<7d}; --> ;{p_f:<12.2f};".format(p_s=name, p_i=count, p_f=betrag))
print("{p_s:>10s}; ;{p_i:>7d}; --> ;{p_f:>12.2f};".format(p_s=name, p_i=count, p_f=betrag))
print("{p_s:^10s}; ;{p_i:^7d}; --> ;{p_f:^12.2f};".format(p_s=name, p_i=count, p_f=betrag))
print("\n")
strOut = "Art: {0:5d}, Price per Unit: {1:8.2f}, {{".format(4523,59.058)               # position parameter; escape { is {{
print(strOut)  # Art:  4523, Price per Unit:    59.06,
strOut1 = "Art: {art:5d}, Price per Unit: {price:8.2f},".format(art=53, price=1259.058)     # named parameter
print(strOut1) # Art:    53, Price per Unit:  1259.06,
print("\n")
# rjust, ljust, center
s = "Python"
print(s.center(10))      # '  Python  '
print(s.center(10, "*"))  # '**Python**'
print("\n")
s = "Training"
print(s.ljust(12))       # 'Training    '
print(s.ljust(12, ":"))  # 'Training::::'
print("\n")
s = "Programming"
print(s.rjust(15))       # '    Programming'
print(s.rjust(15, "~"))  # '~~~~Programming'
print("\n")


print("# Hex, Bin, Octal ")
print("# --------------- ")
h0 = 0xAB
h1str = hex(10)
retType = type(h1str)
print("HEX:", h1str, retType)
print("HEX:{hex1:4X}    DEC: {hex2:10}\n".format(hex1=h0, hex2=h0))

b0 = 0b11111
b1str = bin(10)
retType = type(b1str)
print("BIN:", b1str, retType)
print("BIN: {bin1:10b}    DEC: {bin2:10}\n".format(bin1=b0, bin2=b0))

o0 = 0o12
o1str = oct(10)
retType = type(o1str)
print("OCT:", o1str, retType)
print("OCT: {oct1:10o}    DEC: {oct2:10}\n".format(oct1=o0, oct2=o0))

print("h0 * b0 * o0 = ", h0*b0*o0)
print("\n")

print("# Complexe Zahlen ")
print("# --------------- ")
r = 1-2j
r2 = 5+2j
print(r, "+", r2, "=", r + r2)
print(r, "*", r2, "=", r * r2)
print("\n")


print("........ pythonBasics_01_VarStringPrint.py")


print("==============================================")

def getMp3Name(nr):
    return str(nr).rjust(3, "0") + ".mp3"


print(getMp3Name(3))
print(getMp3Name(12))
print(getMp3Name(123))
anyNr = int(input("Nr:"))
print(getMp3Name(anyNr))
print("==============================================")


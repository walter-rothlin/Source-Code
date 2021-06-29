# ------------------------------------------------------------------
# Name: Exception_Handling_Mitternachtsformel.py
#
# Description:
#
#
# Autor: Florin Curiger
#
# ------------------------------------------------------------------
import math
#   from Library_FC import  *





testfaelle = '''Positive Testfälle: a=2    b=1    c=-4      Diskriminante: 33    x1=1.19   x2=-1.69
Positive Testfälle: a=1    b=0    c=0       Diskriminante:  0    x1,2=0
Negative Testfälle: a=1    b=2    c=3       Diskriminante: -8    x1=-----   x2=-----'''
print(testfaelle)






def Mitternachtsformel():
    #Berschnungen Mitternachtsformel
    diskriminante = b**2 - 4*a*c
    #Schaut ob die diskriminante unter 0 ist
    if diskriminante < 0:
        print('Keine lösung:')
    else:
        x1 = round(float(-b + math.sqrt(diskriminante)) / (2*a), 2)
        x2 = round(float(-b - math.sqrt(diskriminante)) / (2*a), 2)
        print()
        print('Diskriminante:', diskriminante)
        print('x1:', x1)
        print('x2:', x2)
        print()





def readFloat(prompt="float=", errPreMsg="Falsche Eingabe:", errPostMsg=" Must be a float!!!!"):
    global aValue, aS
    error = True
    while error:
        try:
            aS = input(prompt)
            aValue = float(aS)
            error = False
        except ValueError:
            print(errPreMsg + aS + errPostMsg)
            error = True
    return aValue



def readInt(prompt="int (Ganzzahliger Wert)=", preErr="Falsche Eingabe:", postErr=" Must be a int!!!!", min= None, lowerErrMsg="Value must be greater than {m:2d}", max= None, upperErrMsg="Value must be lower than"):
    global aValue
    error = True
    aS = ""
    while error:
        try:
            aS = input(prompt)
            aValue = int(aS)
            if min is not None:
                if (aValue < min):
                    error = True
                    print(lowerErrMsg.format(m=min))
                else:
                    error = False
            else:
                if max is not None:
                    if (aValue > max):
                        error = True
                        print(upperErrMsg.format(m=max))
                    else:
                        error = False
                else:
                    error = False
        except ValueError:
            print(preErr + aS + postErr)
            error = True
    return aValue

ii = readInt()
ii = readInt("Anzahl >0     :", min=0)
ii = readInt("Anzahl <100   :", max=100)
ii = readInt("Anzahl 0..100 :", min=0, max=100)
ii = readInt("Anzahl >10    :", min=10, lowerErrMsg="Wert muss grösser als {m:2d} sein!")

#----------------------------------------------------------------------------------------------------------------------

a = readFloat(prompt="a=", errPreMsg="Wrong format!!")
b = readFloat(prompt="b=")
c = readFloat(prompt="c=")

diskriminante = b**2 - 4*a*c
print("Diskriminante:", diskriminante)

if diskriminante < 0:
        print("keine Lösung möglich!")

else:
    x1 = (-b + math.sqrt(diskriminante))/(2 * a)
    print("x1:", x1)
    x2 = (-b - math.sqrt(diskriminante))/(2 * a)
    print("x2:", x2)

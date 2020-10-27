# Python_EV3: 03_Variablen_Display.py

from grobot import *

thisIsA_String = "Walti's"
thisIsAnOther_String = 'Sie sagt:"Hallo"'

aVarName_1  = 23.45123    # Float
aVarName_2  = 2           # Integer
aVarName_3  = True        # Boolean
aVarName_4  = False       # Boolean
aVarName_5  = "Hal'\nlo"  # String
aVarName_6  = 'Hal"lo'    # String
aVarName_10 = """xxx
yyyy
zzzz
"""                       # Multiline String

clearDisplay()
drawString("012345678901234567", 0, 0)
drawString(aVarName_1, 0,1)
drawString(aVarName_2, 0,2)
drawString(aVarName_3, 0,3)
drawString(aVarName_4, 0,4)
drawString(aVarName_5, 0,5)  # \n (Zeilenumbruch) wird durch einen space ersetzt
drawString(aVarName_6, 0,6)
delay(4000)

clearDisplay()
drawString("012345678901234567", 0, 0)
drawString(aVarName_1 + aVarName_2, 0, 1)
drawString(aVarName_5 + aVarName_6, 0, 2)  
drawString(aVarName_10, 0, 3)              # Zeilenumbruch wird durch einen space ersetzt
delay(4000)

clearDisplay()
drawString("012345678901234567", 0, 0)
drawString("   {i:5d}".format(i=aVarName_2), 0, 1)
drawString("   {f:5.2f}".format(f=aVarName_2), 0, 2)
drawString("   {f:5.2f}".format(f=(12 * aVarName_2)), 0, 3)
delay(4000)
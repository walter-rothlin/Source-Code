#!/usr/bin/python3

'''pruefung_4b_FormatStr.py'''

''' Expected Result:
123456789012345678901234567890
  5 x   50.95 =   254.75
128 x   50.95 =  6521.60
'''

p     = 50.95
anz_1 =   5
anz_2 = 128

pythonLikeFormatStr = "{anz:3d} x {pr:7.2f} = {tot:8.2f}"

print("123456789012345678901234567890")
print(pythonLikeFormatStr.format(anz=anz_1, pr=p, tot=anz_1*p))
print(pythonLikeFormatStr.format(anz=anz_2, pr=p, tot=anz_2*p))








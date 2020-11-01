
import math

help = '''
Berechnung der Nullstellen einer quadratischen Funktion der Form:
   y = ax^2 + bx + c
'''

print(help)
a = float(input("a="))
b = float(input("b="))
c = float(input("c="))

diskriminante = b**2 - 4*a*c
try:
    x1 = (-b + math.sqrt(diskriminante))/(2 * a)
    x2 = (-b - math.sqrt(diskriminante))/(2 * a)
    print("x1 =", x1, "    x1 =", x2)
except ValueError:
    print("Keine Lösung! Diskriminante=", diskriminante)



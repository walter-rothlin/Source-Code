#------------------------------------------------
# polygone.py
#------------------------------------------------
# History:
# 15-Mar-2023 Walter Rothlin  Initial Version
#------------------------------------------------
from gturtle import *

def square(seitenlaenge=70,
           pen_color  = "blue",
           fill_color = None,
           xstart     = 0,
           ystart     = 0,
           pen_size   = 1):
    polygon(seitenlaenge = seitenlaenge,
            anzahl_ecken = 4,
            pen_color    = pen_color,
            fill_color   = fill_color,
            xstart       = xstart,
            ystart       = ystart,
            pen_size     = pen_size)

def polygon(seitenlaenge=70,
            anzahl_ecken=4,
            pen_color="blue",
            fill_color=None,
            xstart=0,
            ystart=0,
            pen_size=1):


    setPos(xstart, ystart)
    setPenWidth(pen_size)
    setPenColor(pen_color)

    if fill_color is not None:
        setFillColor(fill_color)
        startPath()

    repeat anzahl_ecken:
        forward(seitenlaenge)
        left(360/anzahl_ecken)

    if fill_color is not None:
        fillPath()

# Hier beginnt das Hauptprogramm (Main)
makeTurtle()

polygon(fill_color="yellow", anzahl_ecken=7)

repeat 2:
    clean()
    n = inputInt("Gib die Eckenzahl ein")
    laenge = inputInt("Seitenlaenge")
    sd = inputInt("Stiftdicke")
    right(120)
    polygon(laenge, n, "green",
            xstart=40,
            ystart=-100,
            pen_size=sd)
from gturtle import *


def drawVieleck(
         anzahlEcken=4,
         borderColor="red",
         fillColor=None, 
         seitenLaenge=70):

    setPenColor(borderColor)
    if fillColor is not None:
        setFillColor(fillColor)
        startPath()
    repeat anzahlEcken: 
        forward(seitenLaenge) 
        left(360/anzahlEcken)
    if fillColor is not None:
        fillPath()
        
def square(
        borderColor_S="red", 
        fillColor_S=None, 
        seitenLaenge_S=70):
            
    drawVieleck(
        borderColor=borderColor_S,
        fillColor=fillColor_S,
        seitenLaenge=seitenLaenge_S)
        
# Hauptprogramm
makeTurtle()

square(fillColor_S="red")
right(120)

square(borderColor_S="blue")
right(120)

square(borderColor_S="green")

drawVieleck(anzahlEcken=6, borderColor="yellow", seitenLaenge=30)

drawVieleck(8, "blue", None, 80)
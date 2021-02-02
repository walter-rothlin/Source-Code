from gturtle import *

def drawPolygon(anzahlEcken=3, size=70, color="red", fill = False, fillColor = None):
    n = anzahlEcken
    if fill:
        if fillColor is None:
            setFillColor(color)
        else:
            setFillColor(fillColor)
        startPath()
    setPenColor(color)
    repeat n:
        forward(size)
        right(360 / n)
    if fill:
        fillPath()

def drawSquare(size=70, color="red", fill = False, fillColor = None):
    drawPolygon(anzahlEcken=4, size=size, color=color, fill = fill, fillColor = fillColor)

    
makeTurtle()
clearScreen()
anzahlEcken = int(input("Anzahl Ecken:"))
clearScreen()
drawPolygon(anzahlEcken, 10, "blue")
delay(1000)
setPos(-100, -100)
drawSquare()
delay(1000)
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

def drawLine(xStart=0, yStart=-200, xEnd=0, yEnd=200, color="black", endPfeilWinkel=160):
    setPenColor(color)
    setPos(xStart, yStart)
    moveTo(xEnd, yEnd)
    
    # pfeil
    if endPfeilWinkel is not None:
        right(endPfeilWinkel)
        forward(10)
        setPos(xEnd, yEnd)
        left(2*endPfeilWinkel)
        forward(10)
    
    # scale
    einheit = 30
    halfLen = 5
    yPos = -200
    #while yPos < 200:
        # setPos(halfLen, yPos)
        # moveTo(-halfLen, yPos)
        #yPos += einheit
		
makeTurtle()
clearScreen()
anzahlEcken = int(input("Anzahl Ecken:"))
clearScreen()
drawPolygon(anzahlEcken, 10, "blue")
delay(1000)
setPos(-100, -100)
drawSquare()
delay(1000)
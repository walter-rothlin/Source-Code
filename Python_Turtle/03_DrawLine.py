from gturtle import *

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
drawLine()
drawLine(-200,0,200,0,"black",160)
drawLine(xStart=-200, yStart=-200, xEnd=200, yEnd=200, color="red", endPfeilWinkel=None)
drawLine(xStart=-200, yStart=200, xEnd=200, yEnd=-200, color="blue")
setPos(0, 0)
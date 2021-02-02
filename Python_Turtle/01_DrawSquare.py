from gturtle import *


def drawSquare(size=70, color="red", fill = False, fillColor = None):
    if fill:
        if fillColor is None:
            setFillColor(color)
        else:
            setFillColor(fillColor)
        startPath()
    setPenColor(color)
    repeat 4: 
        forward(size) 
        left(90) 
    if fill:
        fillPath()

# Begin of main program

makeTurtle()

print("Blaues ausgefülltes mittleres Quadrat")
drawSquare(color = "blue", fill=True)
right(120)

print("Rotes grosses Quadrat")
drawSquare(150, "red")
right(120)

print("Grün umrahmtes, rot ausgefülltes kleines Quadrat")
drawSquare(size=30, color="green", fill=True, fillColor="red")
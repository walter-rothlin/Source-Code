from gturtle import *

makeTurtle()

print("Schneeflocke")
setPenColor("blue")
repeat 8:
    forward(100)
    dot(20)
    back(100)
    right(45)

delay(5000)
clean()

print("Kreisring")
setPenColor("red")
setX(-200)
repeat 18:
    forward(30)
    dot(10)
    right(20)
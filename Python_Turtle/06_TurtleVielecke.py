from gturtle import *

makeTurtle()

print("Dreieck")
setPenColor("black")
repeat 3:
    forward(100) 
    left(120)
    
print("Quadrat")
setPenColor("red")
repeat 4:
    forward(100) 
    left(90)

print("5-Eck")
setPenColor("green")
repeat 5:
    forward(100) 
    left(72)
    
print("6-Eck")
setPenColor("blue")
repeat 6:
    forward(100) 
    left(60)
    
delay(5000)
clean()

print("5-Eck Stern")
setPenColor("yellow")
repeat 5:
    forward(100) 
    left(145)
    
print("9-Eck Stern")
setPenColor("red")
repeat 9:
    forward(100) 
    left(160)
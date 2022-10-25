from gturtle import *
from random import randint

makeTurtle()

def draw_circle( 
            seitenlaenge=3, 
            border_width=1, 
            border_color="black", 
            fill_color=None):
     draw_vieleck(
            anzahl_ecken = 100,
            seitenlaenge = seitenlaenge,
            border_width = border_width,
            border_color = border_color,
            fill_color   = fill_color)

def draw_square( 
            seitenlaenge=100, 
            border_width=1, 
            border_color="black", 
            fill_color=None):
     draw_vieleck(
            anzahl_ecken = 4,
            seitenlaenge = seitenlaenge,
            border_width = border_width,
            border_color = border_color,
            fill_color   = fill_color)

def draw_vieleck(
            anzahl_ecken, 
            seitenlaenge=100, 
            border_width=1, 
            border_color="black", 
            fill_color=None):
     if fill_color is not None:
         setFillColor(fill_color)
         startPath()
     setPenColor(border_color)
     setPenWidth(border_width)
 
     repeat anzahl_ecken:
         forward(seitenlaenge)
         left(360/anzahl_ecken)
     if fill_color is not None:
         fillPath()
    
    
draw_square(fill_color="green")  # parameter via Name
left(30)
draw_square(50, 4, "blue")  # parameter via Position
left(30)
draw_square(20, 1, "black", "white")  # parameter via Position
print("Tests draw_square() completed!")
delay(3000)
clean()

draw_vieleck(5, 50, 4, "blue")
draw_vieleck(3, 100, 2, fill_color="green", border_color="yellow")
anzahl_ecken=inputInt("Gib die Eckenzahl ein:")
draw_vieleck(anzahl_ecken, 100, 2, fill_color="green", border_color="yellow")
delay(3000)
clean()
print("Tests draw_vieleck() completed!")

msgDlg("Tests mit Kreisen")
draw_circle(seitenlaenge=5, border_width=50, border_color="black", fill_color="blue")
delay(3000)
clean()
print("Tests draw_circle() completed!")

msgDlg("Tests mit rgb-Werten")
red = (255,0,0)
bk_color = (randint(0, 255), randint(0, 255), randint(0, 255))
draw_circle(seitenlaenge=5, border_width=50, border_color=bk_color, fill_color="blue")

delay(3000)
clean()

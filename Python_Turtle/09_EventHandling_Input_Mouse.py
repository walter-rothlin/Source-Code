from gturtle import *


def draw_polygones(seiten_laenge=15, anzahl_ecken=5):
    while seiten_laenge < 100:
        repeat anzahl_ecken:
            forward(seiten_laenge) 
            right(360/anzahl_ecken)
        anzahl_ecken += 1
        seiten_laenge +=15    

def onMouseHit(x, y):
    print("x=", x, "   y=", y)
    anzahl_ecken = inputInt("Anzahl Ecken:")
    seiten_laenge = inputInt("Seitenlaenge:")
    setPos(x, y)
    draw_polygones(seiten_laenge=seiten_laenge, anzahl_ecken=anzahl_ecken)




makeTurtle(mouseHit = onMouseHit)
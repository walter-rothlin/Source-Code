# Beispiel 13.11
#
# Lichterkette
#
from mcpi.minecraft import Minecraft
from mcpi import block
import time


# Klasse für ein Blinklicht
class Blinklicht:
    def __init__(self, mc, intervall, farbe):
        self.mc = mc
        self.pos = None
        self.intervall = intervall
        self.farbe = farbe
        self.zaehler = 0
        self.ein = False  # Aktueller Zustand des Blinklichts

    def setzen(self, x, z):
        # Initiale Positionierung des Blinklichts
        self.pos = self.mc.player.getPos()
        self.pos.x += x
        self.pos.z += z
        self.pos.y = self.mc.getHeight(self.pos.x, self.pos.z)
        self.mc.setBlock(self.pos.x, self.pos.y, self.pos.z, block.WOOL.id)

    def aktualisieren(self):
        self.zaehler += 1

        if self.zaehler >= self.intervall:
            self.zaehler = 0

            self.ein = not self.ein  # Umschalten des Zustands

            if self.ein:
                self.mc.setBlock(self.pos.x, self.pos.y, self.pos.z,
                                 block.WOOL.id, self.farbe)
            else:
                self.mc.setBlock(self.pos.x, self.pos.y, self.pos.z,
                                 block.WOOL.id, 0)


# Sortierfunktion für die Farbe eines Blinklichts
def sortiere_farbe(blinklicht):
    return blinklicht.farbe


# Hauptprogramm
def main():
    mc = Minecraft.create()

    # Eine leere Liste für Blinklichter erzeugen
    blinklichter = []
    anzahl_blinklichter = int(input("Wie viele Blinklichter insgesamt: "))

    for i in range(anzahl_blinklichter):
        # Intervall und Farbe für jedes Blinklicht abfragen
        intervall = int(input("Intervall des Blinklichts:"))
        farbe = int(input("Farb-Index des Blinklichts:"))

        # Blinklicht erzeugen und in Liste einfügen
        licht = Blinklicht(mc, intervall, farbe)
        blinklichter.append(licht)

    # Die Blinklichter farblich sortieren und anschließend positionieren
    blinklichter.sort(key=sortiere_farbe)

    for i in range(anzahl_blinklichter):
        blinklichter[i].setzen(x=i, z=0)

    # Blinklichter aktualisieren
    while True:
        for licht in blinklichter:
            licht.aktualisieren()

        time.sleep(0.25)


main()


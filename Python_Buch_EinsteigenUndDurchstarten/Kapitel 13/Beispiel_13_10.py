# Beispiel 13.10
#
# Blinklichter
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


# Hauptprogramm
def main():
    mc = Minecraft.create()

    licht1 = Blinklicht(mc, intervall=10, farbe=1)
    licht1.setzen(x=2, z=0)

    licht2 = Blinklicht(mc, intervall=5, farbe=4)
    licht2.setzen(x=4, z=4)

    licht3 = Blinklicht(mc, intervall=7, farbe=5)
    licht3.setzen(x=6, z=0)

    while True:
        licht1.aktualisieren()
        licht2.aktualisieren()
        licht3.aktualisieren()
        time.sleep(0.25)


main()

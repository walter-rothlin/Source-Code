# Beispiel 13.9
#
# Wolkenbruch
#
from mcpi.minecraft import Minecraft
from mcpi import block
from random import randint
import time


# Klasse für eine "Regenwolke"
class Wolke:
    def __init__(self, mc, groesse, block_id):
        self.mc = mc
        self.pos = mc.player.getPos()  # Aktuelle Spielerposition merken
        self.groesse = groesse
        self.block_id = block_id

    def regnen(self):
        # Zufällige Position innerhalb der Wolke bestimmen
        x = randint(0, self.groesse)
        y = randint(0, self.groesse)
        # Block platzieren. Er fällt von selbst herunter
        self.mc.setBlock(self.pos.x+x, 63, self.pos.z+y, self.block_id)


# Hauptprogramm
def main():
    mc = Minecraft.create()

    # Zwei Wolken unterschiedlicher Größe erzeugen
    # Nur wenige Blöcke (etwa Sand und Kies) fallen selbstständig herunter
    sandwolke = Wolke(mc, 15, block.SAND.id)
    kieswolke = Wolke(mc, 30, block.GRAVEL.id)

    while True:
        # Die Wolken regnen lassen
        sandwolke.regnen()
        kieswolke.regnen()
        time.sleep(0.2)  # 200 Millisekunden warten


main()

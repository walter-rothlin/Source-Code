# Beispiel 13.6
#
# Pyramidenbau mit for-Schleifen
#
from mcpi.minecraft import Minecraft
from mcpi import block

# Aktuelle Position des Spielers ermitteln
mc = Minecraft.create()
pos = mc.player.getPos()

hoehe = int(input("Bitte Höhe der Pyramide eingeben: "))
breite = hoehe*2 - 1

# Pyramide bauen
for y in range(0, hoehe):
    for x in range(y, breite-y):
        for z in range(y, breite-y):
            mc.setBlock(pos.x+x, pos.y+y, pos.z+z, block.SANDSTONE.id)
